$NetBSD: patch-third__party_cpuinfo_src_x86_netbsd_init.c,v 1.1 2025/01/21 13:36:49 ryoon Exp $

* Add preliminary NetBSD support.

--- third_party/cpuinfo/src/x86/netbsd/init.c.orig	2025-01-17 16:37:03.578563361 +0000
+++ third_party/cpuinfo/src/x86/netbsd/init.c
@@ -0,0 +1,398 @@
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <cpuinfo.h>
+#include <cpuinfo/internal-api.h>
+#include <cpuinfo/log.h>
+#include <netbsd/api.h>
+#include <x86/api.h>
+
+static inline uint32_t max(uint32_t a, uint32_t b) {
+	return a > b ? a : b;
+}
+
+static inline uint32_t bit_mask(uint32_t bits) {
+	return (UINT32_C(1) << bits) - UINT32_C(1);
+}
+
+void cpuinfo_x86_netbsd_init(void) {
+	struct cpuinfo_processor* processors = NULL;
+	struct cpuinfo_core* cores = NULL;
+	struct cpuinfo_cluster* clusters = NULL;
+	struct cpuinfo_package* packages = NULL;
+	struct cpuinfo_cache* l1i = NULL;
+	struct cpuinfo_cache* l1d = NULL;
+	struct cpuinfo_cache* l2 = NULL;
+	struct cpuinfo_cache* l3 = NULL;
+	struct cpuinfo_cache* l4 = NULL;
+
+	struct cpuinfo_netbsd_topology netbsd_topology = cpuinfo_netbsd_detect_topology();
+	if (netbsd_topology.packages == 0) {
+		cpuinfo_log_error("failed to detect topology");
+		goto cleanup;
+	}
+	processors = calloc(netbsd_topology.threads, sizeof(struct cpuinfo_processor));
+	if (processors == NULL) {
+		cpuinfo_log_error(
+			"failed to allocate %zu bytes for descriptions of %" PRIu32 " logical processors",
+			netbsd_topology.threads * sizeof(struct cpuinfo_processor),
+			netbsd_topology.threads);
+		goto cleanup;
+	}
+	cores = calloc(netbsd_topology.cores, sizeof(struct cpuinfo_core));
+	if (cores == NULL) {
+		cpuinfo_log_error(
+			"failed to allocate %zu bytes for descriptions of %" PRIu32 " cores",
+			netbsd_topology.cores * sizeof(struct cpuinfo_core),
+			netbsd_topology.cores);
+		goto cleanup;
+	}
+	/* On x86 a cluster of cores is the biggest group of cores that shares a
+	 * cache. */
+	clusters = calloc(netbsd_topology.packages, sizeof(struct cpuinfo_cluster));
+	if (clusters == NULL) {
+		cpuinfo_log_error(
+			"failed to allocate %zu bytes for descriptions of %" PRIu32 " core clusters",
+			netbsd_topology.packages * sizeof(struct cpuinfo_cluster),
+			netbsd_topology.packages);
+		goto cleanup;
+	}
+	packages = calloc(netbsd_topology.packages, sizeof(struct cpuinfo_package));
+	if (packages == NULL) {
+		cpuinfo_log_error(
+			"failed to allocate %zu bytes for descriptions of %" PRIu32 " physical packages",
+			netbsd_topology.packages * sizeof(struct cpuinfo_package),
+			netbsd_topology.packages);
+		goto cleanup;
+	}
+
+	struct cpuinfo_x86_processor x86_processor;
+	memset(&x86_processor, 0, sizeof(x86_processor));
+	cpuinfo_x86_init_processor(&x86_processor);
+	char brand_string[48];
+	cpuinfo_x86_normalize_brand_string(x86_processor.brand_string, brand_string);
+
+	const uint32_t threads_per_core = netbsd_topology.threads_per_core;
+	const uint32_t threads_per_package = netbsd_topology.threads / netbsd_topology.packages;
+	const uint32_t cores_per_package = netbsd_topology.cores / netbsd_topology.packages;
+	for (uint32_t i = 0; i < netbsd_topology.packages; i++) {
+		clusters[i] = (struct cpuinfo_cluster){
+			.processor_start = i * threads_per_package,
+			.processor_count = threads_per_package,
+			.core_start = i * cores_per_package,
+			.core_count = cores_per_package,
+			.cluster_id = 0,
+			.package = packages + i,
+			.vendor = x86_processor.vendor,
+			.uarch = x86_processor.uarch,
+			.cpuid = x86_processor.cpuid,
+		};
+		packages[i].processor_start = i * threads_per_package;
+		packages[i].processor_count = threads_per_package;
+		packages[i].core_start = i * cores_per_package;
+		packages[i].core_count = cores_per_package;
+		packages[i].cluster_start = i;
+		packages[i].cluster_count = 1;
+		cpuinfo_x86_format_package_name(x86_processor.vendor, brand_string, packages[i].name);
+	}
+	for (uint32_t i = 0; i < netbsd_topology.cores; i++) {
+		cores[i] = (struct cpuinfo_core){
+			.processor_start = i * threads_per_core,
+			.processor_count = threads_per_core,
+			.core_id = i % cores_per_package,
+			.cluster = clusters + i / cores_per_package,
+			.package = packages + i / cores_per_package,
+			.vendor = x86_processor.vendor,
+			.uarch = x86_processor.uarch,
+			.cpuid = x86_processor.cpuid,
+		};
+	}
+	for (uint32_t i = 0; i < netbsd_topology.threads; i++) {
+		const uint32_t smt_id = i % threads_per_core;
+		const uint32_t core_id = i / threads_per_core;
+		const uint32_t package_id = i / threads_per_package;
+
+		/* Reconstruct APIC IDs from topology components */
+		const uint32_t thread_bits_mask = bit_mask(x86_processor.topology.thread_bits_length);
+		const uint32_t core_bits_mask = bit_mask(x86_processor.topology.core_bits_length);
+		const uint32_t package_bits_offset =
+			max(x86_processor.topology.thread_bits_offset + x86_processor.topology.thread_bits_length,
+			    x86_processor.topology.core_bits_offset + x86_processor.topology.core_bits_length);
+		const uint32_t apic_id = ((smt_id & thread_bits_mask) << x86_processor.topology.thread_bits_offset) |
+			((core_id & core_bits_mask) << x86_processor.topology.core_bits_offset) |
+			(package_id << package_bits_offset);
+		cpuinfo_log_debug("reconstructed APIC ID 0x%08" PRIx32 " for thread %" PRIu32, apic_id, i);
+
+		processors[i].smt_id = smt_id;
+		processors[i].core = cores + i / threads_per_core;
+		processors[i].cluster = clusters + i / threads_per_package;
+		processors[i].package = packages + i / threads_per_package;
+		processors[i].apic_id = apic_id;
+	}
+
+	uint32_t threads_per_l1 = 0, l1_count = 0;
+	if (x86_processor.cache.l1i.size != 0 || x86_processor.cache.l1d.size != 0) {
+		/* Assume that threads on the same core share L1 */
+		threads_per_l1 = netbsd_topology.threads / netbsd_topology.cores;
+		if (threads_per_l1 == 0) {
+			cpuinfo_log_error("failed to detect threads_per_l1");
+			goto cleanup;
+		}
+		cpuinfo_log_warning(
+			"netbsd kernel did not report number of "
+			"threads sharing L1 cache; assume %" PRIu32,
+			threads_per_l1);
+		l1_count = netbsd_topology.threads / threads_per_l1;
+		cpuinfo_log_debug("detected %" PRIu32 " L1 caches", l1_count);
+	}
+
+	uint32_t threads_per_l2 = 0, l2_count = 0;
+	if (x86_processor.cache.l2.size != 0) {
+		if (x86_processor.cache.l3.size != 0) {
+			/* This is not a last-level cache; assume that threads
+			 * on the same core share L2 */
+			threads_per_l2 = netbsd_topology.threads / netbsd_topology.cores;
+		} else {
+			/* This is a last-level cache; assume that threads on
+			 * the same package share L2 */
+			threads_per_l2 = netbsd_topology.threads / netbsd_topology.packages;
+		}
+		if (threads_per_l2 == 0) {
+			cpuinfo_log_error("failed to detect threads_per_l1");
+			goto cleanup;
+		}
+		cpuinfo_log_warning(
+			"netbsd kernel did not report number of "
+			"threads sharing L2 cache; assume %" PRIu32,
+			threads_per_l2);
+		l2_count = netbsd_topology.threads / threads_per_l2;
+		cpuinfo_log_debug("detected %" PRIu32 " L2 caches", l2_count);
+	}
+
+	uint32_t threads_per_l3 = 0, l3_count = 0;
+	if (x86_processor.cache.l3.size != 0) {
+		/*
+		 * Assume that threads on the same package share L3.
+		 * However, is it not necessarily the last-level cache (there
+		 * may be L4 cache as well)
+		 */
+		threads_per_l3 = netbsd_topology.threads / netbsd_topology.packages;
+		if (threads_per_l3 == 0) {
+			cpuinfo_log_error("failed to detect threads_per_l3");
+			goto cleanup;
+		}
+		cpuinfo_log_warning(
+			"netbsd kernel did not report number of "
+			"threads sharing L3 cache; assume %" PRIu32,
+			threads_per_l3);
+		l3_count = netbsd_topology.threads / threads_per_l3;
+		cpuinfo_log_debug("detected %" PRIu32 " L3 caches", l3_count);
+	}
+
+	uint32_t threads_per_l4 = 0, l4_count = 0;
+	if (x86_processor.cache.l4.size != 0) {
+		/*
+		 * Assume that all threads share this L4.
+		 * As of now, L4 cache exists only on notebook x86 CPUs, which
+		 * are single-package, but multi-socket systems could have
+		 * shared L4 (like on IBM POWER8).
+		 */
+		threads_per_l4 = netbsd_topology.threads;
+		if (threads_per_l4 == 0) {
+			cpuinfo_log_error("failed to detect threads_per_l4");
+			goto cleanup;
+		}
+		cpuinfo_log_warning(
+			"netbsd kernel did not report number of "
+			"threads sharing L4 cache; assume %" PRIu32,
+			threads_per_l4);
+		l4_count = netbsd_topology.threads / threads_per_l4;
+		cpuinfo_log_debug("detected %" PRIu32 " L4 caches", l4_count);
+	}
+
+	if (x86_processor.cache.l1i.size != 0) {
+		l1i = calloc(l1_count, sizeof(struct cpuinfo_cache));
+		if (l1i == NULL) {
+			cpuinfo_log_error(
+				"failed to allocate %zu bytes for descriptions of "
+				"%" PRIu32 " L1I caches",
+				l1_count * sizeof(struct cpuinfo_cache),
+				l1_count);
+			goto cleanup;
+		}
+		for (uint32_t c = 0; c < l1_count; c++) {
+			l1i[c] = (struct cpuinfo_cache){
+				.size = x86_processor.cache.l1i.size,
+				.associativity = x86_processor.cache.l1i.associativity,
+				.sets = x86_processor.cache.l1i.sets,
+				.partitions = x86_processor.cache.l1i.partitions,
+				.line_size = x86_processor.cache.l1i.line_size,
+				.flags = x86_processor.cache.l1i.flags,
+				.processor_start = c * threads_per_l1,
+				.processor_count = threads_per_l1,
+			};
+		}
+		for (uint32_t t = 0; t < netbsd_topology.threads; t++) {
+			processors[t].cache.l1i = &l1i[t / threads_per_l1];
+		}
+	}
+
+	if (x86_processor.cache.l1d.size != 0) {
+		l1d = calloc(l1_count, sizeof(struct cpuinfo_cache));
+		if (l1d == NULL) {
+			cpuinfo_log_error(
+				"failed to allocate %zu bytes for descriptions of "
+				"%" PRIu32 " L1D caches",
+				l1_count * sizeof(struct cpuinfo_cache),
+				l1_count);
+			goto cleanup;
+		}
+		for (uint32_t c = 0; c < l1_count; c++) {
+			l1d[c] = (struct cpuinfo_cache){
+				.size = x86_processor.cache.l1d.size,
+				.associativity = x86_processor.cache.l1d.associativity,
+				.sets = x86_processor.cache.l1d.sets,
+				.partitions = x86_processor.cache.l1d.partitions,
+				.line_size = x86_processor.cache.l1d.line_size,
+				.flags = x86_processor.cache.l1d.flags,
+				.processor_start = c * threads_per_l1,
+				.processor_count = threads_per_l1,
+			};
+		}
+		for (uint32_t t = 0; t < netbsd_topology.threads; t++) {
+			processors[t].cache.l1d = &l1d[t / threads_per_l1];
+		}
+	}
+
+	if (l2_count != 0) {
+		l2 = calloc(l2_count, sizeof(struct cpuinfo_cache));
+		if (l2 == NULL) {
+			cpuinfo_log_error(
+				"failed to allocate %zu bytes for descriptions of "
+				"%" PRIu32 " L2 caches",
+				l2_count * sizeof(struct cpuinfo_cache),
+				l2_count);
+			goto cleanup;
+		}
+		for (uint32_t c = 0; c < l2_count; c++) {
+			l2[c] = (struct cpuinfo_cache){
+				.size = x86_processor.cache.l2.size,
+				.associativity = x86_processor.cache.l2.associativity,
+				.sets = x86_processor.cache.l2.sets,
+				.partitions = x86_processor.cache.l2.partitions,
+				.line_size = x86_processor.cache.l2.line_size,
+				.flags = x86_processor.cache.l2.flags,
+				.processor_start = c * threads_per_l2,
+				.processor_count = threads_per_l2,
+			};
+		}
+		for (uint32_t t = 0; t < netbsd_topology.threads; t++) {
+			processors[t].cache.l2 = &l2[t / threads_per_l2];
+		}
+	}
+
+	if (l3_count != 0) {
+		l3 = calloc(l3_count, sizeof(struct cpuinfo_cache));
+		if (l3 == NULL) {
+			cpuinfo_log_error(
+				"failed to allocate %zu bytes for descriptions of "
+				"%" PRIu32 " L3 caches",
+				l3_count * sizeof(struct cpuinfo_cache),
+				l3_count);
+			goto cleanup;
+		}
+		for (uint32_t c = 0; c < l3_count; c++) {
+			l3[c] = (struct cpuinfo_cache){
+				.size = x86_processor.cache.l3.size,
+				.associativity = x86_processor.cache.l3.associativity,
+				.sets = x86_processor.cache.l3.sets,
+				.partitions = x86_processor.cache.l3.partitions,
+				.line_size = x86_processor.cache.l3.line_size,
+				.flags = x86_processor.cache.l3.flags,
+				.processor_start = c * threads_per_l3,
+				.processor_count = threads_per_l3,
+			};
+		}
+		for (uint32_t t = 0; t < netbsd_topology.threads; t++) {
+			processors[t].cache.l3 = &l3[t / threads_per_l3];
+		}
+	}
+
+	if (l4_count != 0) {
+		l4 = calloc(l4_count, sizeof(struct cpuinfo_cache));
+		if (l4 == NULL) {
+			cpuinfo_log_error(
+				"failed to allocate %zu bytes for descriptions of "
+				"%" PRIu32 " L4 caches",
+				l4_count * sizeof(struct cpuinfo_cache),
+				l4_count);
+			goto cleanup;
+		}
+		for (uint32_t c = 0; c < l4_count; c++) {
+			l4[c] = (struct cpuinfo_cache){
+				.size = x86_processor.cache.l4.size,
+				.associativity = x86_processor.cache.l4.associativity,
+				.sets = x86_processor.cache.l4.sets,
+				.partitions = x86_processor.cache.l4.partitions,
+				.line_size = x86_processor.cache.l4.line_size,
+				.flags = x86_processor.cache.l4.flags,
+				.processor_start = c * threads_per_l4,
+				.processor_count = threads_per_l4,
+			};
+		}
+		for (uint32_t t = 0; t < netbsd_topology.threads; t++) {
+			processors[t].cache.l4 = &l4[t / threads_per_l4];
+		}
+	}
+
+	/* Commit changes */
+	cpuinfo_processors = processors;
+	cpuinfo_cores = cores;
+	cpuinfo_clusters = clusters;
+	cpuinfo_packages = packages;
+	cpuinfo_cache[cpuinfo_cache_level_1i] = l1i;
+	cpuinfo_cache[cpuinfo_cache_level_1d] = l1d;
+	cpuinfo_cache[cpuinfo_cache_level_2] = l2;
+	cpuinfo_cache[cpuinfo_cache_level_3] = l3;
+	cpuinfo_cache[cpuinfo_cache_level_4] = l4;
+
+	cpuinfo_processors_count = netbsd_topology.threads;
+	cpuinfo_cores_count = netbsd_topology.cores;
+	cpuinfo_clusters_count = netbsd_topology.packages;
+	cpuinfo_packages_count = netbsd_topology.packages;
+	cpuinfo_cache_count[cpuinfo_cache_level_1i] = l1_count;
+	cpuinfo_cache_count[cpuinfo_cache_level_1d] = l1_count;
+	cpuinfo_cache_count[cpuinfo_cache_level_2] = l2_count;
+	cpuinfo_cache_count[cpuinfo_cache_level_3] = l3_count;
+	cpuinfo_cache_count[cpuinfo_cache_level_4] = l4_count;
+	cpuinfo_max_cache_size = cpuinfo_compute_max_cache_size(&processors[0]);
+
+	cpuinfo_global_uarch = (struct cpuinfo_uarch_info){
+		.uarch = x86_processor.uarch,
+		.cpuid = x86_processor.cpuid,
+		.processor_count = netbsd_topology.threads,
+		.core_count = netbsd_topology.cores,
+	};
+
+	__sync_synchronize();
+
+	cpuinfo_is_initialized = true;
+
+	processors = NULL;
+	cores = NULL;
+	clusters = NULL;
+	packages = NULL;
+	l1i = l1d = l2 = l3 = l4 = NULL;
+
+cleanup:
+	free(processors);
+	free(cores);
+	free(clusters);
+	free(packages);
+	free(l1i);
+	free(l1d);
+	free(l2);
+	free(l3);
+	free(l4);
+}

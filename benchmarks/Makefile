SUBDIRS = BIT DCT MS PCM LUD SRAD NQU

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)


clean :
	$(foreach dir, $(SUBDIRS), make -C $(dir) clean;)


results_clean :
	$(foreach dir, $(SUBDIRS), make -C $(dir) results_clean;)


######
#
# Makefile
#
######

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt
PATSLIB=$(PATSHOME)/ccomp/atslib

######

all:: query_interp_dats
regress:: all
regress:: query_interp_dats; ./$<

######

testall:: all regress cleanall

######

%_dats: \
%.dats; \
$(PATSCC) \
-D_GNU_SOURCE -DATS_MEMALLOC_LIBC -o $@ $< -latslib -lssl -lcrypto

######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.o
clean:: ; rm -f *_?ats.c

cleanall:: clean
cleanall:: ; rm -f query_interp_dats
cleanall:: ; rm -rf BDB/

###### end of [Makefile] ######

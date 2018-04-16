######
#
# Cleaning Makefile
#
######

NPM=npm

######

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt
PATSLIB=$(PATSHOME)/ccomp/atslib

######

all:: test_dats
regress:: test_dats; ./$<
cleanall:: ; rm -f test_dats

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
clean:: ; rm -f *.txt

cleanall:: clean

###### end of [Makefile] ######

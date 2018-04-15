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

all:: hash_dats
regress:: hash_dats; ./$<
cleanall:: ; rm -f hash_dats

######

testall:: all regress cleanall

######

%_dats: \
%.dats; \
$(PATSCC) \
-o $@ $< -lssl -lcrypto

######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.o
clean:: ; rm -f *_?ats.c

cleanall:: clean

###### end of [Makefile] ######

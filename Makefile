######
#
# Makefile
#
######

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt
PATSLIB=$(PATSHOME)/ccomp/atslib

MAKE=make

######

pre:: \
lambda
lambda:: ; \
$(MAKE) -C lambda -f Makefile compile

######


all:: pre
all:: run_cli_dats
regress:: all
regress:: run_cli_dats; ./$<
cleanall:: ; rm -f run_cli_dats

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
clean:: \
cleanlam
cleanlam:: ; \
$(MAKE) -C lambda -f Makefile cleanall


cleanall:: clean

###### end of [Makefile] ######

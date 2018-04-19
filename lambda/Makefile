######
#
# Cleaning Makefile
#
######

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt

######

all:: queens_dats
all:: prime_dats
regress:: queens_dats; ./$<
regress:: prime_dats; ./$<
compile:: all regress clean

basic:: test_dats; ./$<

isprime:: regress
isprime:: test_dats; ./$< isprime.txt

numprime:: regress
numprime:: test_dats; ./$< num_prime.txt

queen:: regress
queen:: test_dats; ./$< queens.txt

######

clean:: ; rm -f *~
clean:: ; rm -f *_dats.o
clean:: ; rm -f *_dats.c
clean:: ; rm -f queens_dats
clean:: ; rm -f prime_dats
clean:: ; rm -f test_dats

cleanall:: clean
cleanall:: ; rm -f queens.txt
cleanall:: ; rm -f num_prime.txt
cleanall:: ; rm -f isprime.txt
cleanall:: ; rm -f output.txt

######

%_dats: %.dats; $(PATSCC) -D_GNU_SOURCE -DATS_MEMALLOC_LIBC -o $@ $<

###### end of [Makefile] ######

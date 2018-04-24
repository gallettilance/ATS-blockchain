######
#
# Cleaning Makefile
#
######

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt

MAKE=make

######

compile:: \
fibo
fibo:: ; \
$(MAKE) -C example -f Makefile fibo

compile:: \
fact
fact:: ; \
$(MAKE) -C example -f Makefile fact

compile:: \
isprime
isprime:: ; \
$(MAKE) -C example -f Makefile isprime

compile:: \
numprime
numprime:: ; \
$(MAKE) -C example -f Makefile numprime

compile:: \
queens
queens:: ; \
$(MAKE) -C example -f Makefile queens

compile:: clean

######

all:: test_dats

regress_basic:: test_dats; ./$<

regress_fibo:: fibo
regress_fibo:: test_dats; ./$< example/fibo.txt

regress_fact:: fact
regress_fact:: test_dats; ./$< example/fact.txt

regress_isprime:: isprime
regress_isprime:: test_dats; ./$< example/isprime.txt

regress_numprime:: numprime
regress_numprime:: test_dats; ./$< example/numprime.txt

regress_queens:: queens
regress_queens:: test_dats; ./$< example/queens.txt

######

clean:: ; rm -f *~
clean:: ; rm -f *_dats.o
clean:: ; rm -f *_dats.c
clean:: ; rm -f test_dats
clean:: \
cleanex
cleanex:: ; \
$(MAKE) -C example -f Makefile clean


cleanall:: \
cleanallex
cleanallex:: ; \
$(MAKE) -C example -f Makefile cleanall

cleanall:: clean

######

%_dats: %.dats; $(PATSCC) -D_GNU_SOURCE -DATS_MEMALLOC_LIBC -o $@ $<

###### end of [Makefile] ######

# Copyright (c) 2023 Richard Lincoln

TAG = casecsv/mpc2csv

DATADIR = ../matpower/data
DELIM = ,

CASES = case4gs case5 case6ww case9 case14 case24_ieee_rts case_ieee30 case30 case39 case118 case145 case300 \
case_RTS_GMLC case_ACTIVSg500 case_ACTIVSg2000
#case_ACTIVSg10k case_ACTIVSg25k case_ACTIVSg70k
DATAFILES = $(addprefix $(DATADIR)/, $(addsuffix .m, $(CASES)))
#DATAFILES = $(wildcard $(DATADIR)/case*)

READMES = $(addsuffix /README, $(basename $(notdir $(DATAFILES))))
CASEFILES = $(addsuffix /case.csv, $(basename $(notdir $(DATAFILES))))
BUSFILES = $(addsuffix /bus.csv, $(basename $(notdir $(DATAFILES))))
GENFILES = $(addsuffix /gen.csv, $(basename $(notdir $(DATAFILES))))
BRANCHFILES = $(addsuffix /branch.csv, $(basename $(notdir $(DATAFILES))))
COSTFILES = $(addsuffix /gencost.csv, $(basename $(notdir $(DATAFILES))))

OCTAVE_EVAL = octave-cli --no-gui --eval

all: $(READMES) $(CASEFILES) $(BUSFILES) $(GENFILES) $(BRANCHFILES) $(COSTFILES)

%/README: $(DATADIR)/%.m
	@mkdir -p $(dir $@)
	sed '/^ *$$/q' $< | \
	grep ^% | \
	sed -e 's/^%//g' | \
	sed -e 's/^\s\s\s//g' | \
	sed -e '/^Please see CASEFORMAT for details on the case file format/d' \
	> $@;

%/case.csv: $(DATADIR)/%.m
	@mkdir -p $(dir $@)
	$(OCTAVE_EVAL) "case2csv($(basename $(notdir $<)), '$@', '$(basename $(notdir $<))', '$(DELIM)')";

%/bus.csv: $(DATADIR)/%.m
	@mkdir -p $(dir $@)
	$(OCTAVE_EVAL) "bus2csv($(basename $(notdir $<)), '$@', '$(DELIM)')";

%/gen.csv: $(DATADIR)/%.m
	@mkdir -p $(dir $@)
	$(OCTAVE_EVAL) "gen2csv($(basename $(notdir $<)), '$@', '$(DELIM)')";

%/branch.csv: $(DATADIR)/%.m
	@mkdir -p $(dir $@)
	$(OCTAVE_EVAL) "branch2csv($(basename $(notdir $<)), '$@', '$(DELIM)')";

%/gencost.csv: $(DATADIR)/%.m
	@mkdir -p $(dir $@)
	$(OCTAVE_EVAL) "gencost2csv($(basename $(notdir $<)), '$@', '$(DELIM)')";


casecsv.zip:
	docker run -it --rm -d $(TAG)
	CONTAINER_ID=$$(docker ps -alq) && \
	docker cp $$CONTAINER_ID:$/workspace/casecsv/casecsv.zip $@ && \
	docker stop $$CONTAINER_ID

.PHONY: build
build:
	docker build --progress plain -t $(TAG) .

clean:
	rm -f casecsv.zip
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND = noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
	build-essential git ca-certificates zip curl wget unzip nano \
	octave

ENV OCTAVE_EVAL octave-cli --no-gui --eval

RUN git clone https://github.com/MATPOWER/matpower /workspace/matpower
WORKDIR /workspace/matpower
RUN git checkout 7.1
RUN $OCTAVE_EVAL "install_matpower(1,1,1)"
#RUN $OCTAVE_EVAL "test_mptest(0,1)"
#RUN $OCTAVE_EVAL "test_mips(0,1)"
#RUN $OCTAVE_EVAL "test_matpower(0,1)"


RUN mkdir -p /workspace/mfiles
RUN $OCTAVE_EVAL "addpath('/workspace/mfiles', '-end'); savepath()"
#RUN $OCTAVE_EVAL "path()"
COPY case2csv.m /workspace/mfiles/case2csv.m
COPY bus2csv.m /workspace/mfiles/bus2csv.m
COPY gen2csv.m /workspace/mfiles/gen2csv.m
COPY branch2csv.m /workspace/mfiles/branch2csv.m
COPY gencost2csv.m /workspace/mfiles/gencost2csv.m
COPY dcline2csv.m /workspace/mfiles/dcline2csv.m

RUN mkdir -p /workspace/casecsv
COPY Makefile /workspace/casecsv/Makefile
WORKDIR /workspace/casecsv
RUN make
# RUN find .
# RUN cat case6ww/bus.csv


RUN zip -r casecsv.zip ./case*
#RUN find ./ -name "*.csv" -o -name "*.txt" | tar -cf casedata.tar -T -
RUN ls -alh *.zip

CMD ["octave-cli", "--no-gui"]
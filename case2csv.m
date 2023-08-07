function case2csv(mpc, file, casename, delim)

if nargin < 2
  file = "case.m";
endif
if nargin < 3
  casename = "";
endif
if nargin < 4
  delim = ',';
endif

if isfield(mpc, 'version')
  version = mpc.version;
else
  version = '2';
endif

if isfield(mpc, 'baseMVA')
  baseMVA = mpc.baseMVA;
else
  baseMVA = 1.0;
endif

if isfield(mpc, 'f')
  f = mpc.f;
endif

if (ischar (file))
  [fid, msg] = fopen (file, "wt");
elseif (is_valid_file_id (file))
  [fid, msg] = deal (file, "invalid file number");
else
  error("case2csv: FILE must be a filename string or numeric FID");
endif

if (fid < 0)
  error(["case2csv: " msg]);
endif

case_header = strjoin({"CASENAME", "VERSION", "BASE_MVA"}, delim);
case_header_opf = strjoin({"CASENAME", "VERSION", "BASE_MVA", "F"}, delim);

if isfield(mpc, 'f')
  fprintf(fid, "%s\n", case_header_opf);
  fprintf(fid, "%s%s%s%s%g%s%g\n", casename, sprintf(delim), version, sprintf(delim), baseMVA, sprintf(delim), f);
elseif
  fprintf(fid, "%s\n", case_header);
  fprintf(fid, "%s%s%s%s%g\n", casename, sprintf(delim), version, sprintf(delim), baseMVA);
end

if (ischar(file))
  fclose (fid);
endif
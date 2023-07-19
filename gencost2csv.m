function gencost2csv(mpc, file, delim)

PW_LINEAR = 1;

MODEL = 1;
NCOST = 4;

if ~isfield(mpc, 'gencost') || isempty(mpc.gencost)
  disp('gencost2csv: no gencost data');
  return;
endif

if nargin < 2
  file = "gencost.m";
endif
if nargin < 3
  delim = ',';
endif

if (ischar (file))
  [fid, msg] = fopen (file, "wt");
elseif (is_valid_file_id (file))
  [fid, msg] = deal (file, "invalid file number");
else
  error ("gencost2csv: FILE must be a filename string or numeric FID");
endif

if (fid < 0)
  error (["gencost2csv: " msg]);
endif

header = {"MODEL", "STARTUP", "SHUTDOWN", "NCOST"};
if mpc.gencost(1, MODEL) == PW_LINEAR
  N = (size(mpc.gencost, 2) - NCOST) / 2;
  for i = 1:N
    header{end+1} = sprintf('X%d', i);
    header{end+1} = sprintf('Y%d', i);
  end
else
  N = size(mpc.gencost, 2) - NCOST;
  for i = N-1:-1:0
    header{end+1} = sprintf('C%d', i);
  end
endif

fprintf(fid, "%s\n", strjoin(header, delim));
dlmwrite(fid, mpc.gencost, '-append', 'delimiter', delim, 'precision', '%.9g');

if (ischar (file))
  fclose (fid);
endif
function dcline2csv(mpc, file, delim)

MU_PMIN = 18;

if ~isfield(mpc, 'dcline') || isempty(mpc.dcline)
  disp('dcline2csv: no dcline data');
  return;
endif

if nargin < 2
  file = "dcline.m";
endif
if nargin < 3
  delim = ',';
endif

if (ischar (file))
  [fid, msg] = fopen (file, "wt");
elseif (is_valid_file_id (file))
  [fid, msg] = deal (file, "invalid file number");
else
  error ("dcline2csv: FILE must be a filename string or numeric FID");
endif

if (fid < 0)
  error (["dcline2csv: " msg]);
endif

header0 = strjoin({"F_BUS", "T_BUS", "BR_STATUS", "PF", "PT", "QF", "QT", "VF", "VT", "PMIN", "PMAX", "QMINF", "QMAXF", "QMINT", "QMAXT", "LOSS0", "LOSS1"}, delim);
header_opf = strjoin({"F_BUS", "T_BUS", "BR_STATUS", "PF", "PT", "QF", "QT", "VF", "VT", "PMIN", "PMAX", "QMINF", "QMAXF", "QMINT", "QMAXT", "LOSS0", "LOSS1", "MU_PMIN", "MU_PMAX", "MU_QMINF", "MU_QMAXF", "MU_QMINT", "MU_QMAXT"}, delim);

if size(mpc.dcline, 2) < MU_PMIN
  fprintf(fid, "%s\n", header0);
else
  fprintf(fid, "%s\n", header_opf);
endif
dlmwrite(fid, mpc.dcline, '-append', 'delimiter', delim, 'precision', '%.9g');

if (ischar (file))
  fclose (fid);
endif
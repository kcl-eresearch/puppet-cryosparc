# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cryosparc
#
# @param hpc_directory
#   directory to use
#
# @param hpc_group
#   group to use
#
# @param hpc_gid
#   gid to use
#
# @param hpc_user
#   user for account
#
# @param hpc_uid
#   uid for account
#
# @param admin_email
#   email for cryosparc master instance admin
#
# @param admin_username
#   email for cryosparc master instance admin
#
# @param admin_password
#   email for cryosparc master instance admin
#
# @param admin_fname
#   email for cryosparc master instance admin
#
# @param admin_lname
#   email for cryosparc master instance admin
#
class cryosparc (
  String $hpc_directory,
  String $hpc_group,
  String $hpc_gid,
  String $hpc_user,
  String $hpc_uid,
  String $admin_email,
  String $admin_username,
  String $admin_password,
  String $admin_fname,
  String $admin_lname,
) {
  require cryosparc::install
  require cryosparc::config
}

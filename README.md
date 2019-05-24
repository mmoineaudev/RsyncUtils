# RsyncUtils
Makefile pour factoriser les options rsync afin de les évaluer sur des gros fichier

# Man
doc unix
rsync(1)                                                                                                                                                                                                                       rsync(1)

NAME
       rsync - a fast, versatile, remote (and local) file-copying tool

SYNOPSIS
       Local:  rsync [OPTION...] SRC... [DEST]

       Access via remote shell:
         Pull: rsync [OPTION...] [USER@]HOST:SRC... [DEST]
         Push: rsync [OPTION...] SRC... [USER@]HOST:DEST

       Access via rsync daemon:
         Pull: rsync [OPTION...] [USER@]HOST::SRC... [DEST]
               rsync [OPTION...] rsync://[USER@]HOST[:PORT]/SRC... [DEST]
         Push: rsync [OPTION...] SRC... [USER@]HOST::DEST
               rsync [OPTION...] SRC... rsync://[USER@]HOST[:PORT]/DEST

       Usages with just one SRC arg and no DEST arg will list the source files instead of copying.

DESCRIPTION
       Rsync  is  a  fast  and extraordinarily versatile file copying tool.  It can copy locally, to/from another host over any remote shell, or to/from a remote rsync daemon.  It offers a large number of options that control every
       aspect of its behavior and permit very flexible specification of the set of files to be copied.  It is famous for its delta-transfer algorithm, which reduces the amount of data sent over the network by sending only the  dif‐
       ferences between the source files and the existing files in the destination.  Rsync is widely used for backups and mirroring and as an improved copy command for everyday use.

       Rsync finds files that need to be transferred using a "quick check" algorithm (by default) that looks for files that have changed in size or in last-modified time.  Any changes in the other preserved attributes (as requested
       by options) are made on the destination file directly when the quick check indicates that the file’s data does not need to be updated.

       Some of the additional features of rsync are:

       o      support for copying links, devices, owners, groups, and permissions

       o      exclude and exclude-from options similar to GNU tar

       o      a CVS exclude mode for ignoring the same files that CVS would ignore

       o      can use any transparent remote shell, including ssh or rsh

       o      does not require super-user privileges

       o      pipelining of file transfers to minimize latency costs

       o      support for anonymous or authenticated rsync daemons (ideal for mirroring)

GENERAL
       Rsync copies files either to or from a remote host, or locally on the current host (it does not support copying files between two remote hosts).

       There are two different ways for rsync to contact a remote system: using a remote-shell program as the transport (such as ssh or rsh) or contacting an rsync daemon directly via TCP.  The remote-shell transport is used  when‐
       ever  the  source  or destination path contains a single colon (:) separator after a host specification.  Contacting an rsync daemon directly happens when the source or destination path contains a double colon (::) separator
       after a host specification, OR when an rsync:// URL is specified (see also the "USING RSYNC-DAEMON FEATURES VIA A REMOTE-SHELL CONNECTION" section for an exception to this latter rule).

       As a special case, if a single source arg is specified without a destination, the files are listed in an output format similar to "ls -l".

       As expected, if neither the source or destination path specify a remote host, the copy occurs locally (see also the --list-only option).

       Rsync refers to the local side as the "client" and the remote side as the "server".  Don’t confuse "server" with an rsync daemon -- a daemon is always a server, but a server can be either a daemon or a  remote-shell  spawned
       process.

SETUP
       See the file README for installation instructions.

       Once  installed, you can use rsync to any machine that you can access via a remote shell (as well as some that you can access using the rsync daemon-mode protocol).  For remote transfers, a modern rsync uses ssh for its com‐
       munications, but it may have been configured to use a different remote shell by default, such as rsh or remsh.

       You can also specify any remote shell you like, either by using the -e command line option, or by setting the RSYNC_RSH environment variable.

       Note that rsync must be installed on both the source and destination machines.

USAGE
       You use rsync in the same way you use rcp. You must specify a source and a destination, one of which may be remote.

       Perhaps the best way to explain the syntax is with some examples:

              rsync -t *.c foo:src/

       This would transfer all files matching the pattern *.c from the current directory to the directory src on the machine foo. If any of the files already exist on the remote system then the rsync remote-update protocol is  used
       to  update  the  file  by  sending  only  the  differences in the data.  Note that the expansion of wildcards on the commandline (*.c) into a list of files is handled by the shell before it runs rsync and not by rsync itself
       (exactly the same as all other posix-style programs).

              rsync -avz foo:src/bar /data/tmp

       This would recursively transfer all files from the directory src/bar on the machine foo into the /data/tmp/bar directory on the local machine. The files are transferred in "archive" mode, which ensures that  symbolic  links,
       devices, attributes, permissions, ownerships, etc. are preserved in the transfer.  Additionally, compression will be used to reduce the size of data portions of the transfer.

              rsync -avz foo:src/bar/ /data/tmp

       A  trailing slash on the source changes this behavior to avoid creating an additional directory level at the destination.  You can think of a trailing / on a source as meaning "copy the contents of this directory" as opposed
       to "copy the directory by name", but in both cases the attributes of the containing directory are transferred to the containing directory on the destination.  In other words, each of the following commands copies  the  files
       in the same way, including their setting of the attributes of /dest/foo:

              rsync -av /src/foo /dest
              rsync -av /src/foo/ /dest/foo

       Note also that host and module references don’t require a trailing slash to copy the contents of the default directory.  For example, both of these copy the remote directory’s contents into "/dest":

              rsync -av host: /dest
              rsync -av host::module /dest

       You can also use rsync in local-only mode, where both the source and destination don’t have a ’:’ in the name. In this case it behaves like an improved copy command.

       Finally, you can list all the (listable) modules available from a particular rsync daemon by leaving off the module name:

              rsync somehost.mydomain.com::

       See the following section for more details.

ADVANCED USAGE
       The syntax for requesting multiple files from a remote host is done by specifying additional remote-host args in the same style as the first, or with the hostname omitted.  For instance, all these work:

              rsync -av host:file1 :file2 host:file{3,4} /dest/
              rsync -av host::modname/file{1,2} host::modname/file3 /dest/
              rsync -av host::modname/file1 ::modname/file{3,4}

       Older versions of rsync required using quoted spaces in the SRC, like these examples:

              rsync -av host:'dir1/file1 dir2/file2' /dest
              rsync host::'modname/dir1/file1 modname/dir2/file2' /dest

       This word-splitting still works (by default) in the latest rsync, but is not as easy to use as the first method.

       If you need to transfer a filename that contains whitespace, you can either specify the --protect-args (-s) option, or you’ll need to escape the whitespace in a way that the remote shell will understand.  For instance:

              rsync -av host:'file\ name\ with\ spaces' /dest

CONNECTING TO AN RSYNC DAEMON
       It  is also possible to use rsync without a remote shell as the transport.  In this case you will directly connect to a remote rsync daemon, typically using TCP port 873.  (This obviously requires the daemon to be running on
       the remote system, so refer to the STARTING AN RSYNC DAEMON TO ACCEPT CONNECTIONS section below for information on that.)

       Using rsync in this way is the same as using it with a remote shell except that:

       o      you either use a double colon :: instead of a single colon to separate the hostname from the path, or you use an rsync:// URL.

       o      the first word of the "path" is actually a module name.

       o      the remote daemon may print a message of the day when you connect.

       o      if you specify no path name on the remote daemon then the list of accessible paths on the daemon will be shown.

       o      if you specify no local destination then a listing of the specified files on the remote daemon is provided.

       o      you must not specify the --rsh (-e) option.

       An example that copies all the files in a remote module named "src":

           rsync -av host::src /dest

       Some modules on the remote daemon may require authentication. If so, you will receive a password prompt when you connect. You can avoid the password prompt by setting the environment variable RSYNC_PASSWORD to  the  password
       you want to use or using the --password-file option. This may be useful when scripting rsync.

       WARNING: On some systems environment variables are visible to all users. On those systems using --password-file is recommended.

       You may establish the connection via a web proxy by setting the environment variable RSYNC_PROXY to a hostname:port pair pointing to your web proxy.  Note that your web proxy’s configuration must support proxy connections to
       port 873.

       You may also establish a daemon connection using a program as a proxy by setting the environment variable RSYNC_CONNECT_PROG to the commands you wish to run in place of making a direct socket connection.  The string may con‐
       tain the escape "%H" to represent the hostname specified in the rsync command (so use "%%" if you need a single "%" in your string).  For example:

         export RSYNC_CONNECT_PROG='ssh proxyhost nc %H 873'
         rsync -av targethost1::module/src/ /dest/
         rsync -av rsync:://targethost2/module/src/ /dest/

       The command specified above uses ssh to run nc (netcat) on a proxyhost, which forwards all data to port 873 (the rsync daemon) on the targethost (%H).

USING RSYNC-DAEMON FEATURES VIA A REMOTE-SHELL CONNECTION
       It is sometimes useful to use various features of an rsync daemon (such as named modules) without actually allowing any new socket connections into a system (other than what is already required to allow remote-shell access).
       Rsync supports connecting to a host using a remote shell and then spawning a single-use "daemon" server that expects to read its config file in the home dir of the remote user.  This can be useful if you want  to  encrypt  a
       daemon-style transfer’s data, but since the daemon is started up fresh by the remote user, you may not be able to use features such as chroot or change the uid used by the daemon.  (For another way to encrypt a daemon trans‐
       fer, consider using ssh to tunnel a local port to a remote machine and configure a normal rsync daemon on that remote host to only allow connections from "localhost".)

       From the user’s perspective, a daemon transfer via a remote-shell connection uses nearly the same command-line syntax as a normal rsync-daemon transfer, with the only exception being that you must explicitly set  the  remote
       shell program on the command-line with the --rsh=COMMAND option.  (Setting the RSYNC_RSH in the environment will not turn on this functionality.)  For example:

           rsync -av --rsh=ssh host::module /dest

       If  you  need  to specify a different remote-shell user, keep in mind that the user@ prefix in front of the host is specifying the rsync-user value (for a module that requires user-based authentication).  This means that you
       must give the ’-l user’ option to ssh when specifying the remote-shell, as in this example that uses the short version of the --rsh option:

           rsync -av -e "ssh -l ssh-user" rsync-user@host::module /dest

       The "ssh-user" will be used at the ssh level; the "rsync-user" will be used to log-in to the "module".

STARTING AN RSYNC DAEMON TO ACCEPT CONNECTIONS
       In order to connect to an rsync daemon, the remote system needs to have a daemon already running (or it needs to have configured something like inetd to spawn an rsync daemon for incoming connections on a  particular  port).
       For  full  information  on  how to start a daemon that will handling incoming socket connections, see the rsyncd.conf(5) man page -- that is the config file for the daemon, and it contains the full details for how to run the
       daemon (including stand-alone and inetd configurations).

       If you’re using one of the remote-shell transports for the transfer, there is no need to manually start an rsync daemon.

SORTED TRANSFER ORDER
       Rsync always sorts the specified filenames into its internal transfer list.  This handles the merging together of the contents of identically named directories, makes it easy to remove duplicate filenames,  and  may  confuse
       someone when the files are transferred in a different order than what was given on the command-line.

       If  you  need  a  particular file to be transferred prior to another, either separate the files into different rsync calls, or consider using --delay-updates (which doesn’t affect the sorted transfer order, but does make the
       final file-updating phase happen much more rapidly).

EXAMPLES
       Here are some examples of how I use rsync.

       To backup my wife’s home directory, which consists of large MS Word files and mail folders, I use a cron job that runs

              rsync -Cavz . arvidsjaur:backup

       each night over a PPP connection to a duplicate directory on my machine "arvidsjaur".

       To synchronize my samba source trees I use the following Makefile targets:

           get:
                   rsync -avuzb --exclude '*~' samba:samba/ .
           put:
                   rsync -Cavuzb . samba:samba/
           sync: get put

       this allows me to sync with a CVS directory at the other end of the connection. I then do CVS operations on the remote machine, which saves a lot of time as the remote CVS protocol isn’t very efficient.

       I mirror a directory between my "old" and "new" ftp sites with the command:

       rsync -az -e ssh --delete ~ftp/pub/samba nimbus:"~ftp/pub/tridge"

       This is launched from cron every few hours.

OPTIONS SUMMARY
       Here is a short summary of the options available in rsync. Please refer to the detailed description below for a complete description.

        -v, --verbose               increase verbosity
            --info=FLAGS            fine-grained informational verbosity
            --debug=FLAGS           fine-grained debug verbosity
            --msgs2stderr           special output handling for debugging
        -q, --quiet                 suppress non-error messages
            --no-motd               suppress daemon-mode MOTD (see caveat)
        -c, --checksum              skip based on checksum, not mod-time & size
        -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
            --no-OPTION             turn off an implied OPTION (e.g. --no-D)
        -r, --recursive             recurse into directories
        -R, --relative              use relative path names
            --no-implied-dirs       don't send implied dirs with --relative
        -b, --backup                make backups (see --suffix & --backup-dir)
            --backup-dir=DIR        make backups into hierarchy based in DIR
            --suffix=SUFFIX         backup suffix (default ~ w/o --backup-dir)
        -u, --update                skip files that are newer on the receiver
            --inplace               update destination files in-place
            --append                append data onto shorter files
            --append-verify         --append w/old data in file checksum
        -d, --dirs                  transfer directories without recursing
        -l, --links                 copy symlinks as symlinks
        -L, --copy-links            transform symlink into referent file/dir
            --copy-unsafe-links     only "unsafe" symlinks are transformed
            --safe-links            ignore symlinks that point outside the tree
            --munge-links           munge symlinks to make them safer
        -k, --copy-dirlinks         transform symlink to dir into referent dir
        -K, --keep-dirlinks         treat symlinked dir on receiver as dir
        -H, --hard-links            preserve hard links
        -p, --perms                 preserve permissions
        -E, --executability         preserve executability
            --chmod=CHMOD           affect file and/or directory permissions
        -A, --acls                  preserve ACLs (implies -p)
        -X, --xattrs                preserve extended attributes
        -o, --owner                 preserve owner (super-user only)
        -g, --group                 preserve group
            --devices               preserve device files (super-user only)
            --specials              preserve special files
        -D                          same as --devices --specials
        -t, --times                 preserve modification times
        -O, --omit-dir-times        omit directories from --times
        -J, --omit-link-times       omit symlinks from --times
            --super                 receiver attempts super-user activities
            --fake-super            store/recover privileged attrs using xattrs
        -S, --sparse                handle sparse files efficiently
            --preallocate           allocate dest files before writing
        -n, --dry-run               perform a trial run with no changes made
        -W, --whole-file            copy files whole (w/o delta-xfer algorithm)
        -x, --one-file-system       don't cross filesystem boundaries
        -B, --block-size=SIZE       force a fixed checksum block-size
        -e, --rsh=COMMAND           specify the remote shell to use
            --rsync-path=PROGRAM    specify the rsync to run on remote machine
            --existing              skip creating new files on receiver
            --ignore-existing       skip updating files that exist on receiver
            --remove-source-files   sender removes synchronized files (non-dir)
            --del                   an alias for --delete-during
            --delete                delete extraneous files from dest dirs
            --delete-before         receiver deletes before xfer, not during
            --delete-during         receiver deletes during the transfer
            --delete-delay          find deletions during, delete after
            --delete-after          receiver deletes after transfer, not during
            --delete-excluded       also delete excluded files from dest dirs
            --ignore-missing-args   ignore missing source args without error
            --delete-missing-args   delete missing source args from destination
            --ignore-errors         delete even if there are I/O errors
            --force                 force deletion of dirs even if not empty
            --max-delete=NUM        don't delete more than NUM files
            --max-size=SIZE         don't transfer any file larger than SIZE
            --min-size=SIZE         don't transfer any file smaller than SIZE
            --partial               keep partially transferred files
            --partial-dir=DIR       put a partially transferred file into DIR
            --delay-updates         put all updated files into place at end
        -m, --prune-empty-dirs      prune empty directory chains from file-list
            --numeric-ids           don't map uid/gid values by user/group name
            --usermap=STRING        custom username mapping
            --groupmap=STRING       custom groupname mapping
            --chown=USER:GROUP      simple username/groupname mapping
            --timeout=SECONDS       set I/O timeout in seconds
            --contimeout=SECONDS    set daemon connection timeout in seconds
        -I, --ignore-times          don't skip files that match size and time
            --size-only             skip files that match in size
            --modify-window=NUM     compare mod-times with reduced accuracy
        -T, --temp-dir=DIR          create temporary files in directory DIR
        -y, --fuzzy                 find similar file for basis if no dest file
            --compare-dest=DIR      also compare received files relative to DIR
            --copy-dest=DIR         ... and include copies of unchanged files
            --link-dest=DIR         hardlink to files in DIR when unchanged
        -z, --compress              compress file data during the transfer
            --compress-level=NUM    explicitly set compression level
            --skip-compress=LIST    skip compressing files with suffix in LIST
        -C, --cvs-exclude           auto-ignore files in the same way CVS does
        -f, --filter=RULE           add a file-filtering RULE
        -F                          same as --filter='dir-merge /.rsync-filter'
                                    repeated: --filter='- .rsync-filter'
            --exclude=PATTERN       exclude files matching PATTERN
            --exclude-from=FILE     read exclude patterns from FILE
            --include=PATTERN       don't exclude files matching PATTERN
            --include-from=FILE     read include patterns from FILE
            --files-from=FILE       read list of source-file names from FILE
        -0, --from0                 all *from/filter files are delimited by 0s
        -s, --protect-args          no space-splitting; wildcard chars only
            --address=ADDRESS       bind address for outgoing socket to daemon
            --port=PORT             specify double-colon alternate port number
            --sockopts=OPTIONS      specify custom TCP options
            --blocking-io           use blocking I/O for the remote shell
            --outbuf=N|L|B          set out buffering to None, Line, or Block
            --stats                 give some file-transfer stats
        -8, --8-bit-output          leave high-bit chars unescaped in output
        -h, --human-readable        output numbers in a human-readable format
            --progress              show progress during transfer
        -P                          same as --partial --progress
        -i, --itemize-changes       output a change-summary for all updates
        -M, --remote-option=OPTION  send OPTION to the remote side only
            --out-format=FORMAT     output updates using the specified FORMAT
            --log-file=FILE         log what we're doing to the specified FILE
            --log-file-format=FMT   log updates using the specified FMT
            --password-file=FILE    read daemon-access password from FILE
            --list-only             list the files instead of copying them
            --bwlimit=RATE          limit socket I/O bandwidth
            --stop-at=y-m-dTh:m     Stop rsync at year-month-dayThour:minute
            --time-limit=MINS       Stop rsync after MINS minutes have elapsed
            --write-batch=FILE      write a batched update to FILE
            --only-write-batch=FILE like --write-batch but w/o updating dest
            --read-batch=FILE       read a batched update from FILE
            --protocol=NUM          force an older protocol version to be used
            --iconv=CONVERT_SPEC    request charset conversion of filenames
            --checksum-seed=NUM     set block/file checksum seed (advanced)
        -4, --ipv4                  prefer IPv4
        -6, --ipv6                  prefer IPv6
            --version               print version number
       (-h) --help                  show this help (see below for -h comment)

       Rsync can also be run as a daemon, in which case the following options are accepted:

            --daemon                run as an rsync daemon
            --address=ADDRESS       bind to the specified address
            --bwlimit=RATE          limit socket I/O bandwidth
            --config=FILE           specify alternate rsyncd.conf file
        -M, --dparam=OVERRIDE       override global daemon config parameter
            --no-detach             do not detach from the parent
            --port=PORT             listen on alternate port number
            --log-file=FILE         override the "log file" setting
            --log-file-format=FMT   override the "log format" setting
            --sockopts=OPTIONS      specify custom TCP options
        -v, --verbose               increase verbosity
        -4, --ipv4                  prefer IPv4
        -6, --ipv6                  prefer IPv6
        -h, --help                  show this help (if used after --daemon)

EXIT VALUES
       0      Success

       1      Syntax or usage error

       2      Protocol incompatibility

       3      Errors selecting input/output files, dirs

       4      Requested action not supported: an attempt was made to manipulate 64-bit files on a platform that cannot support them; or an option was specified that is supported by the client and not by the server.

       5      Error starting client-server protocol

       6      Daemon unable to append to log-file

       10     Error in socket I/O

       11     Error in file I/O

       12     Error in rsync protocol data stream

       13     Errors with program diagnostics

       14     Error in IPC code

       20     Received SIGUSR1 or SIGINT

       21     Some error returned by waitpid()

       22     Error allocating core memory buffers

       23     Partial transfer due to error

       24     Partial transfer due to vanished source files

       25     The --max-delete limit stopped deletions

       30     Timeout in data send/receive

       35     Timeout waiting for daemon connection


                                                                                                              21 Dec 2015                                                                                                      rsync(1)

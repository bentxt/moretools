
set cmd $argv[1]

# sets BUFFER_STAMP


set dateformat "%Y%m%d%H%M%S%3N"

set -q XDG_STATE_HOME && set local_state $XDG_STATE_HOME || set local_state $HOME/.local/state

set app_state  $local_state/buffer_app
set buffers  $app_state/buffers

set alphabeter_script $HOME/.dotfiles/Modulinos/Alphabeter.pm
set alphabeter_script_get $HOME/.dotfiles/Modulinos/Picker.pm

function die ; echo "$argv" >&2;  exit 1;  end

mkdir -p $buffers || die "Err: could create dir $buffers"

[ -f "$alphabeter_script" ] || die "Err: no alpha script under $alphabeter_script"
[ -f "$alphabeter_script_get" ] || "Err: no alpha script under $alphabeter_script_get"


function new_bufferfile
   set -l stamp $argv[1]

   [ -n "$stamp" ] || die "Err: not date/time stamp"

   set bufferfile $buffers/$stamp.pick
   echo $bufferfile
end

function get_stamp

   set -l stamp
   set -l os (uname)
   switch  $os
      case Darwin 
         set  stamp (gdate +"$dateformat")
         [ $status -eq 0 ] || die "Err: could not run 'gdate' $state"
       case '*'
         die "Err: os $os not supported yet"
   end
   [ -n "$stamp" ] || die "Err: not date/time stamp"
   echo $stamp
end



if isatty stdin
   if [ -n "$cmd" ] 
      switch $cmd
         case pick
            set filepath $app_state/filepath
            rm -f $filepath
            touch $filepath
            ranger  --choosefile="$filepath" $buffers
            set pickfile (cat $filepath)
            echo $pickfile
            cat $pickfile
         case '*'
            die 'eeeeelse' $cmd 'x'
      end
   else
      set -l lastfile (ls $buffers/*.pick | sort | tail -1)
      set -l stamp $BUFFER_STAMP 
      set -l lastname (basename $lastfile)
      set -l laststamp (path change-extension '' $lastname) 

      if [ -n $stamp ] 
         if [ $stamp -eq $laststamp ] 
            perl $alphabeter_script $lastfile
            echo ------
            echo $lastfile
         else
            echo xxxxx
         end
      else
         die 'assss'
      end
   end
   
   #ranger  --choosefile='fuck' ~/.local/state/buffer_app/
   #set resfile (perl  $alphabeter_script "$bufferfile")
   #echo status is: $status pipestatus is $pipestatus
   #echo "Enter a token"
   #read token
   #set listfile (perl  $alphabeter_script_get "$resfile" "$token")
   #echo "nnnn " $listfile
else # read from pipe
   set -l stamp (get_stamp)
   [ -n "$stamp" ] || die "Err: not date/time stamp"
   set bufferfile (new_bufferfile $stamp) || die "Err: no bufferfile"
   [ -n "$bufferfile" ] || die "Err: no bufferfile"
   if [ -f "$bufferfile" ] 
      die "Err: bufferfile already exists in $bufferfile"
   else
      touch $bufferfile || die "Err: could not create bufferfile $bufferfile"
   end

   while read line
      echo  $line
   end | perl -s  $alphabeter_script -o=$bufferfile
   echo '-----' >&2
   echo "$bufferfile" >&2

   if [ $status -eq 0 ] 
      set -U BUFFER_STAMP $stamp
   else
      set -e -U BUFFER_STAMP
      rm -f "$bufferfile"
       die "Err: something went wrong , deleting buffer $bufferfile"
    end
end

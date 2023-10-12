#! /bin/bash

# Script developed by Sergey Zhyltsov
#This script automates the project building process for microservices on your local machine, including checking and installing required software programs . Creating necessary project directories with pulling code repositories
 
# List of required programs. Add new program name here for installing software 
# IMPORTANT: Do not forget added new condition to the InstallProgram function 
programs=("git" "ssh" "openvpn")

# Workdir where's project location
project_dir="$HOME/Документы/MusicBox"

#Base URL for repositories
#repo_base_url="git@gitlab.musicbox.local:music-box"
repo_base_url="git@github.com:MBox-MusicBox-Portfolio"

# Map of project directories relative to the project_dir and their corresponding repository URLs
declare -A directory_repository_map=(
    		  ["$project_dir/api/auth"]="$repo_base_url/auth.git"
   		  ["$project_dir/api/admin"]="$repo_base_url/admin.git"
   		  ["$project_dir/api/public"]="$repo_base_url/public.git"
   		  ["$project_dir/api/musician"]="$repo_base_url/musician.git"
   		  ["$project_dir/consumer/event.route"]="$repo_base_url/event.route.git"
   		  ["$project_dir/consumer/mailer"]="$repo_base_url/mailer.git"
   		  ["$project_dir/consumer/socket.emitter"]="$repo_base_url/socket.emitter.git"
   		  ["$project_dir/consumer/socket.instance"]="$repo_base_url/socket.instance.git"
    		  ["$project_dir/frontend/admin"]="$repo_base_url/FrontendAdmin.git"
    		  ["$project_dir/frontend/public"]="$repo_base_url/FrontendPublic.git"
    		  ["$project_dir"]="$repo_base_url/common.git"
)

#Installation needed utilities.
#So when we added new name to the lists of required programs , you need to add new condition here
function InstallProgram()
{
    local program="$1"
    case "$program" in
        git)
            echo "Installing $program..."
            sudo apt install git -y
            ;;
        ssh)
            echo "Installing $program..."
             sudo apt install ssh -y
             sudo systemctl enable sshd
            ;;
        openvpn)
            echo "Installing $program..."
            sudo apt install openvpn -y
            ;;
        *)
            echo "Unknown program: $program"
            ;;
    esac
}

#Check software installation 
function CheckSoftwareInstallation()
{ 
  local results=" "
     for program in "${programs[@]}"; do
    	   if which "$program" > /dev/null; then
        	   results+="[$program: Success] "
        	#return 0
    	   else
        	#results+="[$program: Failure] "
        	InstallProgram "$program"
    	   fi
      done
echo "Check software installation: $results " 				 
}


# Commit current code structures to the GitHub
function GitCommitChanges()
{
    local repoLinked="$1"
    	      git init
	      git remote remove origin
    	      git remote add origin $repoLinked
    	      git config --unset-all remote.origin.fetch
    	      git fetch
    	      git add .
    	      git config --global init.defaultBranch main
    	      git config --global http.sslverify false
    	      git push -f origin main
}


function Start()
{
    CheckSoftwareInstallation
    local installation_result=$?
    if [ "$installation_result" -eq 0 ]; then
        for dir in "${!directory_repository_map[@]}"; do
            if CreateFolder "$dir"; then
                 cd "$dir"
                 GitCommitChanges "${directory_repository_map[$dir]}"  
            else
                 echo "The directory $dir doesn't exist and will be created ..."
                 ls "$dir"
            fi        
        done
        echo "Search project directory ...  $directory"  
    else
        echo "Software installation failed, cannot continue."
    fi
       unset directory_repository_map
    unset programs 
}

# Running
Start


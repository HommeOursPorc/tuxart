#!/bin/bash

# Default number of tux to be generated
NBTUX=4

# Progress number added to progress bar in loop
progressi=0
tmp2=0

# delay executing script
delay()
{
    sleep 0.2;
}

# print out executing progress
CURRENT_PROGRESS=0
progress()
{
    PARAM_PROGRESS=$1;
    PARAM_PHASE=$2;

    if [ $CURRENT_PROGRESS -le 0 -a $PARAM_PROGRESS -ge 0 ]  ; then echo -ne "[..........................] (0%)  $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 5 -a $PARAM_PROGRESS -ge 5 ]  ; then echo -ne "[#.........................] (5%)  $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 10 -a $PARAM_PROGRESS -ge 10 ]; then echo -ne "[##........................] (10%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 15 -a $PARAM_PROGRESS -ge 15 ]; then echo -ne "[###.......................] (15%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 20 -a $PARAM_PROGRESS -ge 20 ]; then echo -ne "[####......................] (20%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 25 -a $PARAM_PROGRESS -ge 25 ]; then echo -ne "[#####.....................] (25%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 30 -a $PARAM_PROGRESS -ge 30 ]; then echo -ne "[######....................] (30%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 35 -a $PARAM_PROGRESS -ge 35 ]; then echo -ne "[#######...................] (35%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 40 -a $PARAM_PROGRESS -ge 40 ]; then echo -ne "[########..................] (40%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 45 -a $PARAM_PROGRESS -ge 45 ]; then echo -ne "[#########.................] (45%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 50 -a $PARAM_PROGRESS -ge 50 ]; then echo -ne "[##########................] (50%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 55 -a $PARAM_PROGRESS -ge 55 ]; then echo -ne "[###########...............] (55%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 60 -a $PARAM_PROGRESS -ge 60 ]; then echo -ne "[############..............] (60%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 65 -a $PARAM_PROGRESS -ge 65 ]; then echo -ne "[#############.............] (65%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 70 -a $PARAM_PROGRESS -ge 70 ]; then echo -ne "[###############...........] (70%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 75 -a $PARAM_PROGRESS -ge 75 ]; then echo -ne "[#################.........] (75%) $PARAM_PHASE                             \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 80 -a $PARAM_PROGRESS -ge 80 ]; then echo -ne "[####################......] (80%) $PARAM_PHASE     \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 85 -a $PARAM_PROGRESS -ge 85 ]; then echo -ne "[#######################...] (85%) $PARAM_PHASE  \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 90 -a $PARAM_PROGRESS -ge 90 ]; then echo -ne "[##########################] (100%) $PARAM_PHASE  \r" ; delay; fi;
    if [ $CURRENT_PROGRESS -le 100 -a $PARAM_PROGRESS -ge 100 ];then echo ; echo -ne "Done!\n" ; delay; fi;

    CURRENT_PROGRESS=$PARAM_PROGRESS;

}

# Checking if an argument has been passed to the program
if [ -z $1 ]
then
  echo -e "No .config file specified...\n"
  progress 10 "Now looking for your configuration file..."

  # Creating folder for personal tux and personal kernel configuration file
  mkdir -p PersonalTux
  progress 20 "Creating PersonalTux folder..."

  # Looking if .config is in /boot/config-***
  cat /boot/config-$(uname -r) > PersonalTux/.config

  # If file has not found in previous folder, the program will look in /proc/config.gz
  if [ $? -ne 0 ]
  then
    progress 30 ".config not found in /boot, trying in /proc"
    zcat /proc/config.gz > PersonalTux/.config
    # Checking if previous function produced errors
    if [ $? -ne 0 ]
    then
      echo -e "/proc/config.gz not found, try passing .config file manually with './tuxart.sh -f [filename]'\n"
      echo -e "Type ./tuxart.sh -h for help."
      echo -e "Now exiting the program..."
      exit 1
    fi
  fi
  progress 35 "Configuration file has been found!"

  progress 50 "Your personal Tux is getting assembled..."

  # Calling main function. Tux generator is on!
  python3 main.py PersonalTux/.config

  # Checking if previous function produced errors
  if [ $? -ne 0 ]
  then
    echo -e "Failed to create PersonalTux...\n"
    echo -e "Now exiting the program..."
    exit 1
  fi
  progress 85 "Personal Tux successfully created..."

  # Moving tux in PersonalTux folder
  mv tux_mod.svg PersonalTux/tux_mod.svg
  progress 99 "Your Tux is available in PersonalTux folder..."

  # Ending the job!
  timeout 10 display PersonalTux/tux_mod.svg &
  progress 100
# Checking if parameter -f is passed
elif [ $1 = "-f" ]
then

  # Error control
  if [ -z $2 ]
  then
    echo -e "No .config file specified with -f option, please run ./tuxart.sh -h for more info..."
    exit 1
  fi
  progress 10 "Creating Tux based on : "$2

  # Creating custom tux folder
  mkdir -p CustomTux
  progress 20 "Creating CustomTux folder..."

  progress 50 "Your custom Tux is getting assembled..."

  # Calling main fonction, tux generator is on!
  python3 main.py $2
  if [ $? -ne 0 ]
  then
    echo "\nFailed to create CustomTux..."
    exit 1
  fi
  progress 75 "Custom Tux successfully created..."

  # Moving Tux to custom folder
  mv tux_mod.svg CustomTux/tux_mod.svg
  progress 85 "   Your Tux is available in CustomTux folder..."

  # timeout 10 displaying and terminating the job
  timeout 10 display CustomTux/tux_mod.svg &
  progress 100

# Checking if grid parameter is chosen
elif [ $1 = "--grid" ]
then

  # Control error
  if [ -z $2 ]
  then
    echo -e "A path to a linux kernel folder must be specified, please run ./tuxart.sh -h for mroe info..."
    exit 1
  fi

  # Checking if a folder has been correctly passed as argument
  if [ -d $2 ]
  then
    # Creating folder container for random tuxes
    mkdir -p TuxGallery
    progress 10 "Creating TuxGallery folder..."

    # Cleaning folder if it's full
    if [ "$(ls -A TuxGallery/)" ]; then rm TuxGallery/*; fi

    # Checking if number of tux to produce has been specified
    if [ -z $3 ]
    then
      progress 15 "No number of random Tux specified, now generating 4 random Tux..."
    else
      # Control error for negative numbers
      if [ $3 -gt 0 ]
      then
        NBTUX=$3
      else
        echo -e "Only non negative numbers are allowed!"
        exit 1
      fi
      progress 15 "Now generating $3 Tux!"
    fi

    # Calculating bar advancement
    progressi=`echo "progressi=75/$NBTUX;progressi/=3;progressi" | bc`
    tmp=25
    # Loop for random tux generation
    for i in `seq $NBTUX`;
    do
      progress $tmp "Tux n$i is preparing..."
      cd $2
      make randconfig > /dev/null 2>&1 2>&1
      #Checking if config file has been correctly created
      if [ $? -ne 0 ]
      then
        echo -e "\nFailed to generate random configuration, check path to the linux kernel folder"
        exit 1
      fi
      cd -

      #Incrementing progres bar
      tmp=`echo "tmp=$tmp+$progressi;tmp" | bc`
      progress $tmp "randomTux n$i is getting assembled..."
      mv $2/.config TuxGallery/.config$i

      # Calling main function! Tux generator is on!
      python3 main.py TuxGallery/.config$i
      if [ $? -ne 0 ]
      then
        echo -e "\nFailed to create randomTux..."
        exit 1
      fi

      # Placing a copy of the Tux in TuxGallery folder in both format .png and .svg
      mv tux_mod.svg TuxGallery/tux_mod$i.svg
      cairosvg TuxGallery/tux_mod$i.svg -o TuxGallery/tux_mod$i.png
      tmp=`echo "tmp=$tmp+$progressi;tmp" | bc`
      progress $tmp "randomTux n$i is ready!"

    done

    # Creating grid of tuxes
    progress 90 "Generating .png grid..."
    montage -density 300 -geometry +5+50 -border 5 TuxGallery/tux_mod*.png TuxGallery/TuxFamily.png
    progress 99 "TuxFamily.png is here! Check TuxGallery folder"

    # Displaying image for 10 seconds
    timeout 10 display TuxGallery/TuxFamily.png &
    progress 100


  fi

# Checking if --gif has been passed as argument
elif [ $1 = "--gif" ]
then

    # Control error
    if [ -z $2 ]
    then
      echo -e "A path to a linux kernel folder must be specified, please run ./tuxart.sh -h for more info..."
      exit 1
    fi

    # Checking if a folder has been correctly passed as argument
    if [ -d $2 ]
    then
      # Creating folder container for random tuxes
      mkdir -p TuxGallery
      progress 10 "Creating TuxGallery folder..."

      # Cleaning folder if it's full
      if [ "$(ls -A TuxGallery/)" ]; then rm TuxGallery/*; fi

      # Checking if number of tux to produce has been specified
      if [ -z $3 ]
      then
        progress 15 "No number of random Tux specified, now generating 4 random Tux..."
      else
        # Control error for negative numbers
        if [ $3 -gt 0 ]
        then
          NBTUX=$3
        else
          echo -e "Only non negative numbers are allowed!"
          exit 1
        fi
        progress 15 "Now generating $3 Tux!"
      fi

      # Calculating bar advancement
      progressi=`echo "progressi=75/$NBTUX;progressi/=3;progressi" | bc`
      tmp=25
      # Loop for random tux generation
      for i in `seq $NBTUX`;
      do
        progress $tmp "Tux n$i is preparing..."
        cd $2
        make randconfig > /dev/null 2>&1 2>&1
        #Checking if config file has been correctly created
        if [ $? -ne 0 ]
        then
          echo -e "\nFailed to generate random configuration, check path to the linux kernel folder"
          exit 1
        fi
        cd -

        #Incrementing progres bar
        tmp=`echo "tmp=$tmp+$progressi;tmp" | bc`
        progress $tmp "randomTux n$i is getting assembled..."
        mv $2/.config TuxGallery/.config$i

        # Calling main function! Tux generator is on!
        python3 main.py TuxGallery/.config$i
        if [ $? -ne 0 ]
        then
          echo -e "\nFailed to create randomTux..."
          exit 1
        fi

        # Placing a copy of the Tux in TuxGallery folder in both format .png and .svg
        mv tux_mod.svg TuxGallery/tux_mod$i.svg
        cairosvg TuxGallery/tux_mod$i.svg -o TuxGallery/tux_mod$i.png
        tmp=`echo "tmp=$tmp+$progressi;tmp" | bc`
        progress $tmp "randomTux n$i is ready!"

      done

      # Creating grid of tuxes
      progress 90 "Generating .png grid..."
      convert -delay 100 -loop 0 TuxGallery/tux_mod*.png TuxGallery/SuperTux.gif
      progress 99 "SuperTux.gif is here! Check TuxGallery folder"

      # Displaying image for 10 seconds
      display TuxGallery/SuperTux.gif &
      progress 100


    fi


# Checking if --rgb has been passed as argument
elif [ $1 = "--rgb" ]
then
  progress 5 "Creating tuxRGB Folder"
  mkdir -p tuxRGB

  # Control error
  if [ -z $2 ]
  then
    echo -e "A path to a linux kernel folder must be specified, please run ./tuxart.sh -h for more info..."
    exit 1
  fi

  # Cleaning tuxRGB folder if not empty
  if [ "$(ls -A tuxRGB/)" ]; then rm tuxRGB/*; fi
  cd $2

  # Creating configuration files with all yes, no or module options activated
  progress 10 "Generating all yes configuration"
  make allyesconfig > /dev/null 2>&1
  mv .config allyes.config

  progress 20 "Generating all no configuration"
  make allnoconfig > /dev/null 2>&1
  mv .config allno.config

  progress 30 "Generating all active modules configuration"
  make allmodconfig > /dev/null 2>&1
  mv .config allmod.config

  cd -
  progress 40 "Moving new configuration files"
  mv $2/allyes.config tuxRGB/
  mv $2/allno.config tuxRGB/
  mv $2/allmod.config tuxRGB/

  # Generating tuxes frmo allyesconfig, allnoconfig and allmodconfig
  progress 50 "Generating Fire Tux"
  python3 main.py tuxRGB/allyes.config
  if [ $? -ne 0 ]
  then
    echo -e "\nFailed to create Fire Tux..."
    exit 1
  fi
  mv tux_mod.svg tuxRGB/redtux.svg

  progress 60 "Generating Aqua Tux"
  python3 main.py tuxRGB/allno.config
  if [ $? -ne 0 ]
  then
    echo -e "\nFailed to create Aqua Tux..."
    exit 1
  fi
  mv tux_mod.svg tuxRGB/bluetux.svg

  progress 70 "Generating Leaf Tux"
  python3 main.py tuxRGB/allmod.config
  if [ $? -ne 0 ]
  then
    echo -e "\nFailed to create Leaf Tux..."
    exit 1
  fi
  mv tux_mod.svg tuxRGB/greentux.svg

  # Displaying generated tuxes for 10 seconds
  progress 95 "Summoning elemenTux!"
  timeout 10 display tuxRGB/redtux.svg &
  timeout 10 display tuxRGB/greentux.svg &
  timeout 10 display tuxRGB/bluetux.svg &

  progress 100

# Checking if help option has been passed as argument
elif [ $1 = "-h" -o $1 = "--help" ]
then
# This is the help section !!
  echo "Welcome to tuxart!"
  echo "You can quickly generate your tux by typing ./tuxart.sh"
  echo
  echo "Specific arguments can be passed to ./tuxart.sh with the following syntax : "
  echo
  echo "        * ./tuxart.sh -f [filename]"
  echo "                  This will generate a tux for the given configuration file"
  echo
  echo "        * ./tuxart.sh --grid [path to linux kernel folder] [n]"
  echo "                  This will generate a grid of n tux. n = 4 if not specified"
  echo
  echo "        * ./tuxart.sh --rgb [path to linux kernel folder]"
  echo "                  This will generate 3 tux corresponding to 3 linux kernel configuration with all possible options to yes, no or module"
  echo
  echo "        * ./tuxart/sh --gif [path to linux kernel folder] [n]"
  echo "                  This will generate a .gif of n tux. n = 4 if not specified"

# If non recognizible argument has been passed, throw an error
else
  echo "Bad syntax. Type ./tuxart -h for help..."
  exit 1
fi

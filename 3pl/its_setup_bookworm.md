# [Android 14 Camera Image Test Suite Release Notes](https://source.android.google.cn/docs/compatibility/cts/its-release-notes-14)

## Install conda
    wget -c https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -u
Press `Q` to skip the EULA and type `yes` to accept the license terms  
Press `Enter` to use the default installation path  
Type `no` or press `Enter` to not use conda init  
  
  
## Build the environment
    source ~/miniconda3/bin/activate
    conda create --name its python=3.9.2
    conda activate its
    conda install opencv numpy=1.20.3		# OpenCV 4.2.0 is n/a, install a suitable version (v4.6.0) instead
    conda install matplotlib=3.4.3 pillow=8.3.1		# Matplotlib 3.4.1 is n/a, install v3.4.3 instead
    conda install scipy		# Scipy 1.6.2 conflicts with the env, install a suitable version (v1.10.1) instead
    conda install pyserial=3.5 pyyaml=5.4.1
    pip install mobly==1.11

(For Display P3 tests only) the following command will un-install pillow-8.3.1 and install pillow-10.1.0  

    pip install colour-science==0.4.2

  
## Test the environment
    cd path_to_CameraITS
    source build/envsetup.sh

  
## Exit the environment
    conda deactivate

  
## Re-enter the environment
    source ~/miniconda3/bin/activate its

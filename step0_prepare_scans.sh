#!/usr/bin/env bash
## prepare files for pre-processing ##
## author: Hailey Trier / 8 Nov 2021 ##

umask u+rw,g+rw # give group read/write permissions to all new files
set -e    # stop immediately on error

subjDir=/Volumes/Seagate_storage/Foraging_study_copy2/

echo "Starting to prepare data..."

# Iterate through subject directories and preprocess all scans from each session
for d in $subjDir*sub*/ ; do  # d=/Volumes/Seagate_storage/Foraging_study_copy2/sub105/
    echo "Preprocessing $d..."

	processDir=$d/preproc_scans_16Feb2022
	rawScansDir=$d/raw

	# Proceed with preprocessing if no preexisting folder found
	if [ ! -d $processDir ]; then
		mkdir -p $processDir;

		# Find scans
  	structural=$(find $rawScansDir -type f -name "*MPRAGE*nii.gz*")
  	fmap_phas=$(find $rawScansDir -type f -name "*grefieldmapping*2001*nii.gz*")
  	fmap_mag=$(find $rawScansDir -type f -name "*grefieldmapping*1001*nii.gz*")
  	epi_run=$(find $rawScansDir -type f -name "*functional*nii*")
    sbepi=$(find $rawScansDir -type f -name "*cmrrmbep*.nii.gz")

		# Correct the axis labels and the orientation
		echo "Correcting orientation..."

  		echo "Correcting $fmap_mag"
        fslreorient2std $fmap_mag $processDir/"fmap_mag.nii.gz"

  		echo "Correcting $fmap_phas"
        fslreorient2std $fmap_phas $processDir/"fmap_phas.nii.gz"

		echo "Correcting $epi_run"
		fslreorient2std $epi_run $processDir/"epiRun"

        echo "Correcting $sbepi"
        fslreorient2std $sbepi $processDir/"epiSB.nii.gz"

        echo "Correcting $structural"
	    fslreorient2std $structural $processDir/"structural.nii.gz"

		echo "All orientations corrected."

		echo "Running BET..."
        bet $processDir/fmap_mag $processDir/fmap_mag_brain
        fslmaths $processDir/fmap_mag_brain -ero $processDir/fmap_mag_brain_ero

		bet $processDir/structural $processDir/structural_brain -f 0.1 -B
        rm $processDir/"structural_brain_mask.nii.gz"

		bet $processDir/"epiSB" $processDir"/epiSB_brain" -f 0.1 -B
		rm $processDir/"epiSB_brain_mask.nii.gz"

		echo "Finished running BET."

		echo "Preparing fmap phase image..."
        # Make sure you change the deltaTE parameter according to your experiment
		Fsl_prepare_fieldmap SIEMENS $processDir/fmap_phas $processDir/fmap_mag_brain_ero $processDir/fmap_rads 1.02

		echo "Finished preparing fmap phase image."
	fi
done

echo "All preparations done"

#!/bin/bash

no_thetas=(30 40)
final_atomic_nos=(30)
electron_scattering=("True" "False")
line_disable=("True" "False")
min=5000
ranges=(1000 2000)
for thetas in ${no_thetas[@]}
do
	for atomic_no in ${final_atomic_nos[@]}
	do
		for scattering in ${electron_scattering[@]}
		do
			for range in ${ranges[@]}
			do
				for line_dis in ${line_disable[@]}
				do
					max=$((min + range))
					command="
					.model.final_atomic_number = ${atomic_no} |
					.opacity.disable_electron_scattering = ${scattering} |
					.opacity.line.disable = ${line_dis} |
					.opacity.line.max = \"${max} AA\" |
					.opacity.line.min = \"${min} AA\" |
					.no_of_thetas = ${thetas}
					"
					#echo $command
					yq -i "$command" profile.yml
					python -u -m cProfile -o profs/${thetas}_${atomic_no}_${scattering}_${min}_${max}_${line_dis}.prof run_stardis.py
					if [ $? -eq 0 ]
					then
						mv foo.png plots/${thetas}_${atomic_no}_${scattering}_${min}_${max}_${line_dis}.png
					else
						echo "Output = $?"
						echo "Failed for (${thetas}_${atomic_no}_${scattering}_${min}_${max}_${line_dis})"
						echo "Removing this version"
						rm profs/${thetas}_${atomic_no}_${scattering}_${min}_${max}_${line_dis}.prof
					fi
				done
			done
		done
	done
done

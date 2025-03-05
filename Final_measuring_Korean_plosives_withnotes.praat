form: "Korean plosives"
	folder: "Folder name", "fortis"
endform

soundFiles$# = fileNames$# (folder_name$ + "/*.wav")

writeInfoLine: "Speaker", tab$, "Gender", tab$, "Age", tab$, "File", tab$, "Plosive", tab$, 
... "Burst_dur_ms", tab$, "Burst_energy_norm_ms", tab$, 
... "Afterburst_dur_ms", tab$, "Vowel_dur_ms", tab$, "f0_median", tab$, "f0_first_third", tab$, "f0_last_third", tab$, "f0_ratio", tab$,  "notes"
for ifile to size (soundFiles$#)
	soundFile$ = soundFiles$# [ifile]

	#
	# Get speaker info (gender and age) from file name
	#
	name$ = soundFile$ - ".wav"
	hyphenlocation = index(name$, "-")
	speaker$ = mid$ (name$, hyphenlocation + 1, 3)
	gender$ = mid$ (name$, hyphenlocation + 4, 1)
	age = number (mid$ (name$, hyphenlocation + 5, 2))

	textgridFile$ = name$ + ".TextGrid"
	sound = Read from file: folder_name$ + "/" + soundFile$
	pitch1 = To Pitch (ac): 0.001, 75, 15, "no", 0.03, 0.45, 0.1, 0.35, 0.14, 600
	# to avoid octave jumps: octave cost set high (0.1), octave-jump cost standard setting (0.35) 
	selectObject: sound
	pitch2 = To Pitch (ac): 0.001, 75, 15, "no", 0.03, 0.45, 0.01, 0, 0.14, 600
	# to measure if there is a difference between first third and third third, with no octave jump cost (0)
	textgrid = Read from file: folder_name$ + "/" + textgridFile$

	#
	# Get duration of burst, after-burst and vowel, burst energy and median pitch of vowel
	#
	n = Get number of intervals: 1
	for i to n
		label$ = Get label of interval: 1, i
		if label$ <> ""
			tminBurst = Get starting point: 1, i
			tmaxBurst = Get end point: 1, i
			durBurst = tmaxBurst - tminBurst
			j = Get interval at time: 2, tminBurst
			plosive$ = Get label of interval: 2, j
			tmaxAfterburst = Get end point: 2, j		
			durAfterbur = tmaxAfterburst - tmaxBurst 
			tminVowel = Get starting point: 2, j + 1
			tmaxVowel = Get end point: 2, j + 1
			durVowel = tmaxVowel - tminVowel
			tNotes = Get interval at time: 4, tminBurst
			notes$ = Get label of interval: 4, tNotes
			selectObject: pitch1
			f0 = Get quantile: tminVowel, tmaxVowel, 0.50, "hertz"
			selectObject: pitch2
			f0FirstThird = Get quantile: tminVowel, tminVowel+(durVowel/3), 0.50, "hertz"
			f0ThirdThird = Get quantile: tminVowel+2*(durVowel/3), tmaxVowel, 0.50, "hertz"
			f0Ratio = f0ThirdThird / f0FirstThird
			if f0Ratio = undefined
				exitScript: "No voicing in interval ", i, " of TextGrid ", name$, "."
			endif
			if index (label$, "B")
				selectObject: sound
				energyBurst = Get energy: tminBurst, tmaxBurst
				powerVowel = Get power: tminVowel, tmaxVowel
				energyBurstNorm = energyBurst/powerVowel
			else
				energyBurstNorm = undefined
				durBurst = undefined
			endif
			selectObject: textgrid
		endif
	endfor

	appendInfoLine:speaker$, tab$, gender$, tab$, age, tab$, name$, tab$, plosive$, tab$, 
	... fixed$ (durBurst * 1000, 2), tab$, fixed$ (energyBurstNorm * 1000, 2), tab$, 
	... fixed$ (durAfterbur * 1000, 2), tab$, fixed$ (durVowel * 1000, 2), tab$, 
	... if f0 = undefined then "NA" else fixed$ (f0, 3) fi, tab$, 
	... if f0FirstThird = undefined then "NA" else fixed$ (f0FirstThird, 3) fi, tab$, 
	... if f0ThirdThird = undefined then "NA" else fixed$ (f0ThirdThird, 3) fi, tab$, 
	... fixed$ (f0Ratio, 3), tab$, notes$
	removeObject: sound, textgrid, pitch1, pitch2
endfor

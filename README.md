# Fortis Measures Script

Here's a script for measuring burst and F0 ratio in Praat. We used this for our Kos INTERSPEECH submission in 2024. 

In order to use this script, you need to have ensured your vowel is correctly annotated. We indicated a burst as using capital B in the textgrid. 

Depending on your data, you may need to change 'hyphenlocation', as this was set to our data which was in the form 1001-s01m23.

The script does the following:
  Find the minimum and maximum burst, and the duration between the two. 
  Get the label of the plosive.
  Calculate the 'after burst', i.e. time between the burst and the onset of the vowel.
  Find minimum and maximum of the vowel, and calculate the duration between the two.
  Calculate the ratio of the F0 between the first and final third of the vowel. 
  Calculate the burst energy using a normalised over time measure. 


Note the following:
<ul>
<li>pitch1 = To Pitch (ac): 0.001, 75, 15, "no", 0.03, 0.45, 0.1, 0.35, 0.14, 600 </li>
<li>pitch2 = To Pitch (ac): 0.001, 75, 15, "no", 0.03, 0.45, 0.01, 0, 0.14, 600 </li>
</ul>

Pitch1 keeps the octave jump cose at 0.35 (disallowing some jumps), and the octave cost at 0.1. This favours higher F0 frequency and allows some jumps. <br/>
Pitch2 allows all jumps by setting octave jump cost to 0, and disfavours a higher F0 candidate by remaining at 0.01. <br/>

You should adjust the pitch floor and ceiling accordingly! Here we leave it at 75-600Hz, but you may want to change that depending on your speakers. Creak often has a lower F0, and we found it helpful to lower the floor even further for all speakers then is standard.

The burst energy is normalised over time, so the output is in milliseconds rather than another unit of measurement.

All further information can be found in our 2024 Interspeech paper. If you would like to use this script directly, then it would be much appreciated if you could cite us or our Interspeech paper:

<ul>
  	Michaela Watkins, Paul Boersma & Silke Hamann: Revisiting pitch jumps: F0 ratio in Seoul Korean. <i>Proceedings of Interspeech</i> 2024, Kos, 1–5 September 2024. 3135–3139.
</ul>

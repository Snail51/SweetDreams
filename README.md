# Sweet Dreams

## Purpose
 - This branch of the "Sweet Dreams" repo is solely for storing alternative versions of the audio files that make up the program.
 - Particularly, all files are available in their original state to make it easier to redo the audio effects as new processes become available.

## Directory Guide:
 - `1_source` - all the files in their completely original states, as found in their original sources. Literally nothing has been touched.
 - `2_edit` - first round of executive parsing; substantive changes (trimming, etc.). NOT AUTOMATED
   - files in this directory should include instructions on how they were edited
 - `3_ogg` - no effects applied to audio files. All files converted to `.ogg` with proper metadata and `detox`ed filenames. Exported at absolute max quality (`Sample Rate: 44100Hz`, `Nominal Bitrate: 500kbps`)
 - `4_normalize` - the following audacity macro applied to `edit`:
   - LoudnessNormalization:DualMono="1" LUFSLevel="-23" NormalizeTo="0" RMSLevel="-20" StereoIndependent="0"
   - Normalize:ApplyVolume="1" PeakLevel="-2" RemoveDcOffset="1" StereoIndependent="0"
   - Compressor:attackMs="30" compressionRatio="10" kneeWidthDb="5" lookaheadMs="1" makeupGainDb="0" releaseMs="150" showActual="1" showInput="0" showOutput="1" showTarget="0" thresholdDb="-10"
   - NoiseGate:ATTACK="10" DECAY="150" GATE-FREQ="0" HOLD="50" LEVEL-REDUCTION="-12" MODE="Gate" STEREO-LINK="LinkStereo" THRESHOLD="-40"
   - ExportOgg:SampleRate="44100Hz" Quality="5" NominalBitrate="160kbps"

########## AviSynth 2.5 script for my guitar video Loop1.4
########## ===============================================
########## By Oce // oceweb@gmail.com // http://www.youtube.com/user/OceYT // Licence CC-BY 3.0

# WARNING THIS SCRIPT IS IN PROGRESS AND CERTAINLY DOESN'T WORK

# I highly recommand the user interface AvsPmod 2.4.1 (or later) to read the script.
# How AvsPmod looks like: http://i.imgur.com/h8r5fjO.png

/* I encode the .avs script into a classic video format, .mov (h.264) for the video and .wav for the sound.

Usually the h.264 is used with mp4 for video and the crappy (Silver Fruit's) .aac for audio. 
But aac is a compressed format and as it is a video for music, I want to preserve the uncompressed .wav quality 
of my audio. .mp4 doesn't accept .wav, so I use .mov and it works perfectly well on at least VirtualDub, WMP, 
VLC, and Youtube.

To encode I use the free open source FFmpeg (64 static build from Zeranoe) + VLC or VirtualDub to read the video.
Command lines I use (make sure you're in the same folder as ffmpeg.exe):
1) For ~fast MQ encoding when I need to check a change quickly :
ffmpeg -i F:\Videos\Loops\Loops4_1\MosaiqueLoop4_1.avs -c:v libx264 -preset fast -crf 30 -c:a copy F:\Videos\Loops\Loops4_1\crf64sdX.mov
2) For even faster check, but no user interface (can't stop,back), you can use FFplay (comes with ffmpeg dowload),
it will read the script without encoding:
ffplay F:\Videos\Loops\Loops4_1\Script.avs
3) For very slow but HQ video and efficient compression (for Youtube):
ffmpeg -i F:\Videos\Loops\Loops4_1\MosaiqueLoop4_1.avs -c:v libx264 -preset veryslow -crf 16 -c:a copy F:\Videos\Loops\Loops4_1\crf64hd.mov
*/

# Beginnin of the script itself:
#__________________________________________________________

## I - INTRO

## Define w widht, h heigth, t number of frames of 1 loop
w=1920 
h=1080
t=337

#### A - Sources

/*NOTE: sources are called with 2 ways: FFVideoSource is requested for AviSynth 64 bits (so FFmpeg MUST be 64 bits).
BUT AvsPmod is 32 bits only : ( , so you have to switch to the QTInput blocks to use the preview in AvsPmod.
CONCLUSION: to use AvsPmod preview, comment (/* */) "FFVideoSource block" and enable "QTInput blocks".
if you then encode with 64 bits FFmpeg (so AviSynth MUST be 64), enable the first one and comment the second one.
The smartest way might be to chose FFmpeg 32 bits (so AviSynth MUST be 32) so you can use QTInput in both case.
But, I'm not. */

#/*# Load the plugin FFMS2, needed for .MOV in ffmpeg/avisynth 64bits, but AvsPmod won't recognize it
loadplugin("C:\Program Files (x86)\AviSynth 2.5\plugins64\ffms2-x64.dll")
intro1 = FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0031.MOV", threads=1).Killaudio.Trim(0,201)
intro2 = FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0032.MOV", threads=1).Killaudio.Trim(0,153)
intro3 = FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0033.MOV", threads=1).crop(0,40,0,0).BicubicResize(w, h, b=0, c=-13).Killaudio.Trim(0,123) # using strange b and c values to create effects
intro4 = FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0034.MOV", threads=1).crop(0,100,0,0).BicubicResize(w, h, b=9, c=0).Killaudio.Trim(53,150)#*/
/*# Load the plugin QTSource to use the QTInput function needed for .MOV sources in 32bits --> and if you  wanna see it in AvsPmod (32bits only) to find erros easly
loadplugin("C:\Program Files (x86)\AviSynth 2.5\plugins\qtsource.dll")
intro1 = QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0031.MOV").Killaudio.Trim(0,201)
intro2 = QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0032.MOV").Killaudio.Trim(0,153)
intro3 = QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0033.MOV").crop(0,40,0,0).BicubicResize(w, h, b=0, c=-13).Killaudio.Trim(0,123) # using strange b and c values to create effects
intro4 = QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0034.MOV").crop(0,100,0,0).BicubicResize(w, h, b=9, c=0).Killaudio.Trim(53,150)#*/
oceascii = ImageSource("F:\Videos\Loops\Loops4_1\images\oceascii.png").ConvertToRGB32(matrix="Rec601", interlaced=false)
blank = BlankClip(width=w,height=h,fps=23.976023,length=10*t, color=$000000).Killaudio.BicubicResize(w, h, b=0.33, c=0.33).ConvertToYUY2().AssumeFPS(intro1)# Create a blank black clip for editing tricks and future mosaique construction

#### B - Mix and overlay

intro1a = intro1.Trim(0,170)
introa = Overlay(intro1a, intro2, mode="subtract", opacity=0.5) 
introb = Overlay(introa, intro3, mode="multiply", opacity=0.5)
introc = Greyscale(Overlay(introb, intro4, mode="add", opacity=0.5))

intro1b = Greyscale(intro1.Trim(171,201).Tweak(bright=-30))
introd = Dissolve(introc,intro1b,30).ConvertToYUY2().BicubicResize(w, h, b=0.33, c=0.33)
back = ImageSource("F:\Videos\Loops\Loops4_1\images\oceascii.png",pixel_type="RGB32").ShowAlpha(pixel_type="RGB32")
oceasciia = oceascii.AddBorders(491,54,491, 54, color=$000000)
oceasciib = Layer(oceasciia, back, level=256, x=480, y=60).Loop(100).AssumeFPS(introd).ConvertToYUY2().BicubicResize(w, h, b=0.33, c=0.33).Trim(0,40)
introe = Dissolve(introd, oceasciib, 20)
introe= Dissolve(blank.Trim(0,24), introe, 20)
introe= Dissolve(introe, blank.Trim(0,24), 20)

aintro = WAVSource("F:\Videos\Loops\Loops4_1\Loop 2.4r.wav")
introaudio = Audiodub(blank, aintro).Trim(80, 300)
introf = AudioDubEx(introe,introaudio)

intro = introf.Fadeout2(40)


## II - BODDY

#### A - Sources

#/*# Load the plugin FFMS2, needed for .MOV in ffmpeg/avisynth 64bits, but AvsPmod won't recognize it
loadplugin("C:\Program Files (x86)\AviSynth 2.5\plugins64\ffms2-x64.dll")
clip1 = FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0007.MOV", threads=1).Killaudio.Trim(135,t+135-1) #OK
clip2 = FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0009.MOV", threads=1).Killaudio.Trim(155,t+155-1) #Ok
clip3 = FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0012.MOV", threads=1).Killaudio.Trim(34,t+34-1) #overlay
black = BlankClip(width=w,height=h,fps=23.976023,length=10*t, color=$000000).Killaudio.ConvertToYV12().AssumeFPS(clip1)# Create a blank black clip for editing tricks and future mosaique construction
#clip4v1 = (black.Trim(0,t-1)+FFVideoSource("F:\Videos\Loops\Loops1_4\Brut\DSC_0018.MOV", threads=1).Killaudio.Trim(t+86-5,t+86-1)+FFVideoSource("F:\Videos\Loops\Loops1_4\Brut\DSC_0018.MOV", threads=1).Killaudio.Trim(89,t+84-1)).Crop(0,200,0,0).Killaudio.BicubicResize(w/r, h/r, b=0.33, c=0.33)
#Source0012 overlaps on 2 loops--> put the 4 last frames at beginning
clip4 = FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0018.MOV", threads=1).Killaudio.Trim(t+86-4,t+86-1)+FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0018.MOV", threads=1).Killaudio.Trim(86,t+82-1)#overlay
clip5 = FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0025.MOV", threads=1).Killaudio.Trim(84,t+84-1)#OK
clip6 = FFVideoSource("F:\Videos\Loops\Loops4_1\Brut\DSC_0026.MOV", threads=1).Killaudio.Trim(225,t+225-1)#OK*/ 
/*## Load the plugin QTSource to use the QTInput function needed for .MOV sources in 32bits --> and if you  wanna see it in AvsPmod (32bits only) to find erros easly
loadplugin("C:\Program Files (x86)\AviSynth 2.5\plugins\qtsource.dll")
clip1 = QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0007.MOV").Killaudio.Trim(135,t+135-1) #OK
clip2 = QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0009.MOV").Killaudio.Trim(155,t+155-1) #overlay http://avisynth.org/mediawiki/Overlay
clip3 = QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0012.MOV").Killaudio.Trim(34,t+34-1) #overlay
black = BlankClip(width=w,height=h,fps=23.976023,length=t, color=$000000).Killaudio.ConvertToYuY2().AssumeFPS(clip1)# Create a blank black clip for editing tricks and future mosaique construction
#clip4v1 = (black.Trim(0,t-1)+FFVideoSource("F:\Videos\Loops\Loops1_4\Brut\DSC_0018.MOV", threads=1).Killaudio.Trim(t+86-5,t+86-1)+FFVideoSource("F:\Videos\Loops\Loops1_4\Brut\DSC_0018.MOV", threads=1).Killaudio.Trim(89,t+84-1)).Crop(0,200,0,0).Killaudio.BicubicResize(w/r, h/r, b=0.33, c=0.33)
#Source0012 overlaps on 2 loops--> put the 4 last frames at beginning
clip4 = QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0018.MOV").Killaudio.Trim(t+86-4,t+86-1)+QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0018.MOV").Killaudio.Trim(86,t+82-1)#overlay
clip5 = QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0025.MOV" ).Killaudio.Trim(84,t+84-1)#overlay
clip6 = QTInput("F:\Videos\Loops\Loops4_1\Brut\DSC_0026.MOV").Killaudio.Trim(225,t+225-1)#overlay#*/

#/*
#### B - Face overlay http://avisynth.org/mediawiki/Overlay

oce = ImageSource("F:\Videos\Loops\Loops4_1\images\OceForLoops.png")
bg=ImageReader("F:\Videos\Loops\Loops4_1\images\OceForLoops.png",pixel_type="RGB32").ShowAlpha(pixel_type="RGB32") #Mask needed to use the transparency of the png overlay
clip1 = Overlay(clip1, oce, x=720, y=-450, mask=bg)
clip2 = Overlay(clip2, oce, x=1040, y=-375, mask=bg)
clip3 = Overlay(clip3, oce, x=850, y=-500, mask=bg)
clip4 = Overlay(clip4, oce.BicubicResize(632, 660, b=0.33, c=0.33), x=865, y=-320, mask=bg.BicubicResize(632, 660, b=0.33, c=0.33))
clip5 = Overlay(clip5, oce, x=775, y=-450, mask=bg)
clip6 = Overlay(clip6, oce, x=775, y=-375, mask=bg)


#### C - Scenes

###### 1 - Scene 1
couleur = $191919  # highlight border color

r = 3 # resize factore, 
sc1 = clip1.BicubicResize(w/r, h/r, b=0.33, c=0.33).AddBorders(20,20,20,20, color=couleur).AddBorders(350,187,350,187).BicubicResize(w, h, b=0.33, c=0.33)#OK

###### 2 - Scene 2
w2 = 600 # width for boxes # WARNING: some resize values won't work when encoding with ffmpeg (depends on codec?), while there is no problem with AvsPmod prevue... My guess is that w AND r must be rational, here w7 = w/r = 1920/3,2 = 1920/(16/5) = 600
h2 = 300 #  heigth for boxes # r = 18/5 different from w3, so proportions is not 16/9, but I think, well chosen Addborders parameters+Resize will guarantee the 16/9 final format of the boxes, and it looks like it works.
lr2 = 80 # left-right border
tb2 = 370 # top-bot border
clip2sc2 = clip2.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(0, lr2/4, lr2/4, lr2/4, color=couleur).AddBorders(0, 0, lr2*3/4, 0, color=$000000) 
clip1sc2 = clip1.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(lr2, lr2/4, 560+200, lr2/4, color=$000000)
sc2 = StackHorizontal(clip2sc2,clip1sc2).AddBorders(0, tb2, 0, tb2, color=$000000).BicubicResize(w, h, b=0.33, c=0.33)

###### 3 - Scene 3
clip2sc3 = clip2.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(0, lr2/4, lr2, lr2/4, color=$000000) 
clip1sc3 = clip1.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(lr2, lr2/4, lr2, lr2/4, color=$000000)
clip3sc3 = clip3.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(lr2/4, lr2/4, 0, lr2/4, color=couleur).AddBorders(lr2*3/4, 0, 0, 0, color=$000000)
sc3 = StackHorizontal(clip2sc3,clip1sc3, clip3sc3).AddBorders(0, tb2, 0, tb2, color=$000000).BicubicResize(w, h, b=0.33, c=0.33)

###### 4 - Scene 4
tb4 = 140
clip3sc4 = clip3.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(lr2, lr2/4, 0, lr2/4, color=$000000)
sc4a = StackHorizontal(clip2sc3,clip1sc3, clip3sc4).AddBorders(0, tb4, 0, tb4/2, color=$000000).BicubicResize(w, h/2, b=0.33, c=0.33)
sc4b = clip4.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(lr2/4, lr2/4, lr2/4, lr2/4, color=couleur).AddBorders(lr2*3/4+680, lr2*3/4, lr2*3/4+680,lr2*3/4+tb4, color=$000000).BicubicResize(w, h/2, b=0.33, c=0.33)
sc4 = StackVertical(sc4a, sc4b)

###### 5 - Scene 5
clip5sc5 = clip5.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(0, lr2/4, lr2/4, lr2/4, color=couleur).AddBorders(0, 0, lr2*3/4, 0, color=$000000)
clip4sc5 = clip4.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(lr2, lr2/4, lr2+680,lr2/4, color=$000000)
sc5a = sc4a
sc5b = StackHorizontal(clip5sc5, clip4sc5).AddBorders(0, tb4/2, 0, tb4, color=$000000).BicubicResize(w, h/2, b=0.33, c=0.33)
sc5 = StackVertical(sc5a,sc5b)


###### 6 - Scene 6
clip5sc6 = clip5.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(0, lr2/4, lr2,lr2/4, color=$000000)
clip4sc6 = clip4.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(lr2, lr2/4, lr2,lr2/4, color=$000000)
clip6sc6 = clip6.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(lr2/4, lr2/4, 0, lr2/4, color=couleur).AddBorders(lr2*3/4, 0, 0, 0, color=$000000)
sc6a = sc4a
sc6b = StackHorizontal(clip5sc6, clip4sc6, clip6sc6).AddBorders(0, tb4/2, 0, tb4, color=$000000).BicubicResize(w, h/2, b=0.33, c=0.33)
sc6 = StackVertical(sc6a,sc6b)

###### 7 - Scene 7
clip6sc7 = clip6.BicubicResize(w2, h2, b=0.33, c=0.33).AddBorders(lr2, lr2/4, 0, lr2/4, color=$000000)
sc7a = sc4a
sc7b = StackHorizontal(clip5sc6, clip4sc6, clip6sc7).AddBorders(0, tb4/2, 0, tb4, color=$000000).BicubicResize(w, h/2, b=0.33, c=0.33)
sc7 = StackVertical(sc7a,sc7b)


## III - OUTRO #*/


## VI - AUDIO + FINAL BUILD

return intro
#/*


## Add Audio, convert into a fake video to be able to use trim() on it.
audio = WAVSource("F:\Videos\Loops\Loops4_1\Loop4_1.wav")
vaudio = AudioDub(black,audio).Trim(0*t,7*t-1)
#clip6 = AudioDubEx(clip5,audio)

cliptest = 
cliptesta = audiodubex(cliptest, vaudio)

return cliptesta #*/

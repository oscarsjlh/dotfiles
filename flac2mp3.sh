#! /bin/bash
ss_downloads=/mnt/main/soulseekt
music_folder=/mnt/main/Musica

cd $ss_downloads || {
	echo "check path"
	exit 1
}
for f in *.flac; do ffmpeg -i "${f}" -ab 320k -map_metadata 0 -id3v2_version 3 "${f%.*}".mp3; done
mv ./*.mp3 $music_folder
rm ./*.flac
rm ./*.jpg

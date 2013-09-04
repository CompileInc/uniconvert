#! /bin/bash

input_file=$1
page=$2

fullfile=$input_file
filename=$(basename "$fullfile")
extension="${filename##*.}"
extension=`echo $extension | tr [A-Z] [a-z]`
filename="${filename%.*}"
dir=$(dirname "$fullfile")

pdf='pdf'

pdf_file=$dir/$filename.$pdf
non_pdf=0

if [ $extension != $pdf ]
then
    non_pdf=1
    cmd="libreoffice --headless --convert-to pdf --outdir $dir $fullfile"
    eval $cmd
fi

if [ -f $pdf_file ]
then
    cmd="convert -density 1024 $pdf_file[$page] $dir/$filename.jpg"
    echo $cmd
    eval $cmd
    if [ $non_pdf -eq 1 ]
    then
        cmd='rm $pdf_file'
        eval $cmd
    fi
else
    if [ $non_pdf -eq 1 ]
    then
        echo "Unable to convert from the provided non pdf"
        exit 99
    else
        echo "No pdf file found"
        exit 98
    fi
fi

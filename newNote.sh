notesDirectory="/home/zamza/Documents/HS/Semester VI/"
noteTemplateDir="/home/zamza/Documents/HS/Notes Template/"

noteSubject=
noteName=

chooseSubject () {
    noteSubject=$(ls "$notesDirectory" | rofi -dmenu -p "Choose Subject")
}

enterNoteName () {
    noteName=$(ls "$notesDirectory/$noteSubject" | rofi -dmenu -p "Enter Note Name")
}

createNoteDirectory () {
    mkdir "$notesDirectory/$noteSubject/$noteName" &>/dev/null
    mkdir "$notesDirectory/$noteSubject/$noteName/graphics" &>/dev/null
}

copyTemplateFiles () {
    cp -n "$noteTemplateDir/notes_template.tex" "$notesDirectory/$noteSubject/$noteName/${noteName}.tex"
}

chooseSubject

while [ ! -d "$notesDirectory/$noteSubject" ]
do
    chooseSubject
done

if [ -z "$noteSubject" ]
then
    exit 1
fi

enterNoteName

if [ -z "$noteName" ]
then
    exit 1
fi

createNoteDirectory

echo "$notesDirectory/$noteSubject/$noteName/" | cat > previousNote.txt

notePath="$notesDirectory/$noteSubject/$noteName/"
latexFile="$notePath/${noteName}.tex"
pdfFile="$notePath/${noteName}.pdf"

copyTemplateFiles

emacs "$latexFile" &
zathura "$pdfFile" &

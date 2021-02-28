inkTemplate="/home/zamza/Documents/HS/Notes Template/graphics/graphicsTemplate.svg"
noteDir=$(cat < previousNote.txt)
actions=( "New/Edit Graphic" "Delete Graphic" )

getFileNameWithRofi () {
    # $1: Message
    ls "$noteDir/graphics" | sed 's/\.[^.]*$//' | sort -u | rofi -dmenu -p "$1" | sed 's/\.[^.]*$//'
}

createEditGraphic () {
    fileName=$(getFileNameWithRofi "Name of Graphic")

    if [ -z "$fileName" ]
    then
        exit 1
    fi

    filePath="$noteDir/graphics/${fileName}.svg"

    cp -n "$inkTemplate" "$filePath"

    inkscape "$filePath"

    inkscape -D --export-latex --export-type="pdf" "$filePath"

    echo "
    \begin{figure}
    \centering
    \import{graphics/}{${fileName}.pdf_tex}
    \end{figure}" | xclip -selection c
}

deleteGraphic () {
    file=$(getFileNameWithRofi "Select Graphic to delete")

    if [ -z "$file" ]
    then
        error 1
    fi

    rm "$noteDir/graphics/${file}".*
}


selectedAction=$(printf '%s\n' "${actions[@]}" | rofi -dmenu -p "Choose Action")

if [[ ! " ${actions[@]} " =~ " ${selectedAction} " ]]
then
    exit 1
fi

if [ "$selectedAction" == "${actions[0]}" ]
then
    createEditGraphic

elif [ "$selectedAction" == "${actions[1]}" ]
then
    deleteGraphic

fi

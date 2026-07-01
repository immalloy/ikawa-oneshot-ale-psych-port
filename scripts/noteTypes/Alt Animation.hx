function onNoteHit(note, character, rating, timeDistance, removeNote)
{
    if (note.noteType == 'Alt Animation' && note.strumLineConfig.sing != null)
        note.strumLineConfig.sing += 'alt';
}

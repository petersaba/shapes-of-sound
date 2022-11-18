<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class TranscribeController extends Controller
{
    function transcribeAudio(Request $request){
        $base64_encoded_audio = $request->encoded_audio;
        $decoded_audio = base64_decode($base64_encoded_audio);

        file_put_contents('../python/audio.wav', $decoded_audio);
    }
}

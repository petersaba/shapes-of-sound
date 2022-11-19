<?php

namespace App\Http\Controllers;

use App\Models\Recording;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TranscribeController extends Controller
{
    function transcribeAudio(Request $request){
        $current_date = date('Y-m-d-H-i-s');
        $user_id = Auth::id();

        $audios_path = '../python/audios/';
        if (!is_dir($audios_path)){
            mkdir($audios_path);
        }

        $audio_folder = $audios_path . $user_id . '/';
        if (!is_dir($audio_folder)){
            mkdir($audio_folder);
        }
        $audio_path = $audio_folder . $current_date . '.wav';

        $base64_encoded_audio = $request->encoded_audio;
        $decoded_audio = base64_decode($base64_encoded_audio);

        file_put_contents($audio_path, $decoded_audio);
        $recording = new Recording;
        $recording->user_id = $user_id;
        $recording->recording_url = $audio_path;

        // if($recording->save()){
            return response()->json([
                'success' => TRUE
            ]);
        // }
    }
}

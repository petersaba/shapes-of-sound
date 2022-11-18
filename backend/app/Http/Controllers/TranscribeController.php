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
        $base64_encoded_audio = $request->encoded_audio;
        $decoded_audio = base64_decode($base64_encoded_audio);

        file_put_contents('../python/audios/' . $user_id . $current_date . '.wav', $decoded_audio);
        $recording = new Recording;
        $recording->user_id = $user_id;
        $recording->recording_url = '../python/audios/' . $user_id . $current_date . '.wav';

        if($recording->save()){
            return response()->json([
                'success' => TRUE
            ]);
        }
    }
}

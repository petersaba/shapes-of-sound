<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\TranscribeController;
use Illuminate\Support\Facades\Route;



Route::post('signup', [AuthController::class, 'createUser']);
Route::post('transcribe', [TranscribeController::class, 'transcribeAudio']);

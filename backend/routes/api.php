<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\TranscribeController;
use Illuminate\Support\Facades\Route;



Route::get('test', [AuthController::class, 'test']);
Route::post('transcribe', [TranscribeController::class, 'transcribeAudio']);

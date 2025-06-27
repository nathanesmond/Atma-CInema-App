<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\JadwalTayang;
use Exception;

class JadwalTayangController extends Controller
{
    public function fetchAll()
    {
        try{

            $jadwalTayang = JadwalTayang::all();
            
            if(!$jadwalTayang){
                return response()->json([
                "status" => false,
                "message" => 'gagal',
                "data" => null,
            ], 401);
            }else{
                return response()->json([
                    "status" => true,
                    "message" => 'berhasil',
                    "data" => $jadwalTayang,
                ], 200);
            }

        }catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => 'gagal',
                "data" => $e->getMessage(),
            ], 401);
        }
    }

    public function fetchByIdFilm($id){
        try{
            $jadwalTayang = JadwalTayang::with(['film', 'studio', 'jadwal'])->where('idFilm', $id)->get();
            
            if(!$jadwalTayang){
                return response()->json([
                "status" => false,
                "message" => 'Not Found',
                "data" => null,
            ], 404);
            }else{
                return response()->json([
                    "status" => true,
                    "message" => 'berhasil',
                    "data" => $jadwalTayang,
                ], 200);
            }

        }catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => 'gagal',
                "data" => $e->getMessage(),
            ], 401);
        }
    }
}

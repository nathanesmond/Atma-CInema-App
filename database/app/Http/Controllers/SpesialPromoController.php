<?php

namespace App\Http\Controllers;

use App\Models\SpesialPromo;
use Illuminate\Http\Request;
use Exception;

class SpesialPromoController extends Controller
{
    public function fetchAll()
    {
        try{
            $spesialPromo = SpesialPromo::all();
            
            if(!$spesialPromo){
                return response()->json([
                "status" => false,
                "message" => 'gagal',
                "data" => null,
            ], 401);
            }else{
                return response()->json([
                    "status" => true,
                    "message" => 'berhasil',
                    "data" => $spesialPromo,
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

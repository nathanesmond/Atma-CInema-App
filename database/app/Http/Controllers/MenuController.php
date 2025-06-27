<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Menu;
use Exception;

class MenuController extends Controller
{
    public function fetchAll()
    {
        try{

            $menu = Menu::all();
            
            if(!$menu){
                return response()->json([
                "status" => false,
                "message" => 'gagal',
                "data" => null,
            ], 401);
            }else{
                return response()->json([
                    "status" => true,
                    "message" => 'berhasil',
                    "data" => $menu,
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

    public function find($nama)
    {
        try{
            $menu = Menu::query()->where('nama', 'like', $nama . '%')->get(); // kalau nampilin semua nama agus
            
            if(!$menu){
                return response()->json([
                "status" => false,
                "message" => 'gagal',
                "data" => null,
            ], 401);
            }else{
                return response()->json([
                    "status" => true,
                    "message" => 'berhasil',
                    "data" => $menu,
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

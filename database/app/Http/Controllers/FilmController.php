<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Film;
use App\Models\Review;
use Exception;

class FilmController extends Controller
{
    public function fetchAll()
    {
        try{

            $film = Film::all();
            
            if(!$film){
                return response()->json([
                "status" => false,
                "message" => 'gagal',
                "data" => null,
            ], 401);
            }else{
                return response()->json([
                    "status" => true,
                    "message" => 'berhasil',
                    "data" => $film,
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

    public function find($judul)
    {
        try{
            $film = Film::query()->where('judul', 'like', $judul . '%')->get(); // kalau nampilin semua nama agus
            
            if(!$film){
                return response()->json([
                "status" => false,
                "message" => 'gagal',
                "data" => null,
            ], 401);
            }else{
                return response()->json([
                    "status" => true,
                    "message" => 'berhasil',
                    "data" => $film,
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

    public function updateRating($id)
    {
        try{
            $film = Film::find($id);
            $review = Review::query()->where('idFilm',$id)->get();
            print('testtetete');
            $totalRating = $review->sum('rating');
            $totalReview = $review->count();
            $rating = $totalRating / $totalReview;

            $film->jumlahRating = $rating;
            $film->save();

            if(!$film){
                return response()->json([
                "status" => false,
                "message" => 'gagal',
                "data" => null,
            ], 401);
            }else{
                return response()->json([
                    "status" => true,
                    "message" => 'berhasil',
                    "data" => $film,
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

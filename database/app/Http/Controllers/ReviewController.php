<?php

namespace App\Http\Controllers;

use Exception;
use Illuminate\Http\Request;
use App\Models\Review;
use Illuminate\Support\Facades\Storage;

class ReviewController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'idFilm' => 'required',
            'idHistory' => 'required',
            'rating' => 'required|numeric',
            'review' => 'required|string',
        ]);

        try {
            $review = Review::create([
                'idFilm' => $request->idFilm,
                'idHistory' => $request->idHistory,
                'rating' => $request->rating,
                'review' => $request->review,
            ]);
    
            return response()->json([ // respon ketika berhasil
                "status" => true,
                "message" => "Create Review Successful",
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Error: ' . $e->getMessage(),
                'history' => [],
            ], 400);
        }
    }

    public function index($id)
    {
        $review = Review::query()->where('idHistory', $id)->get();

        if (!$review) {
            return response()->json([
                'status' => false,
                'message' => 'Review not found',
                'review' => null,
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Review data fetched successfully',
            'review' => $review,
        ], 200);
    }
}

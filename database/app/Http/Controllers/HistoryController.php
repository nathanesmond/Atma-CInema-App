<?php

namespace App\Http\Controllers;

use App\Models\Transaksi;
use App\Models\History;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Exception;

class HistoryController extends Controller
{
    public function index(Request $request)
    {
        try {
            $userId = Auth::id();

            if ($userId == null) {
                return response()->json([
                    'status' => false,
                    'message' => 'No user found',
                    'history' => [],
                ], 404);
            }

            $historyData = History::with([
                'transaksi',
                'transaksi.pemesananTiket.JadwalTayang.film',
                'transaksi.pemesananTiket.JadwalTayang.studio',
            ])
            ->where('idUser', $userId)
            ->get();
            
            if ($historyData->isEmpty()) {
                return response()->json([
                    'status' => false,
                    'message' => 'No history found for this user',
                    'history' => [],
                ], 404);
            }

            return response()->json([
                'status' => true,
                'message' => 'History, transaction, and ticket reservation data retrieved successfully',
                'history' => $historyData,
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Error: ' . $e->getMessage(),
                'history' => [],
            ], 400);
        }
    }

    public function store(Request $request)
    {
        $request->validate([
            'idTransaksi' => 'required',
            'idUser' => 'required',
            'status' => 'required',
            'isReview' => 'required|integer|max:1',
        ]);
        
        try {

            History::create([
                'idTransaksi' => $request->idTransaksi,
                'idUser' => $request->idUser,
                'status' => $request->status,
                'isReview' => $request->isReview,
            ]);

            return response()->json([
                "status" => true,
                "message" => "Create History Successful",
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Error: ' . $e->getMessage(),
                'history' => [],
            ], 400);
        }
    }

    public function update(Request $request, $id)
    {
        $request->validate([
            'status' => 'required',
            'isReview' => 'required',
        ]);

        $history = History::find($id);

        try {
            $history->update([
                'status' => $request->status,
                'isReview' => $request->isReview,
            ]);

            return response()->json([
                "status" => true,
                "message" => "Update History Successful",
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Error: ' . $e->getMessage(),
                'history' => [],
            ], 400);
        }
    }
}

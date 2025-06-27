<?php

namespace App\Http\Controllers;

use App\Models\Transaksi;
use App\Models\PemesananTiket;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class TransaksiController extends Controller
{
    // Store a new transaksi
    public function store(Request $request)
    {
        // Validate incoming request data
        $validator = Validator::make($request->all(), [
            'idUser' => 'required', // Ensure the user exists
            'idPemesananTiket' => 'required', // Ensure PemesananTiket exists
            'metodePembayaran' => 'required|string', // Validate the payment method
            'totalHarga' => 'required|numeric', // Validate total price
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422); // 422 Unprocessable Entity
        }

        try {
            // Create a new Transaksi record
            $transaksi = Transaksi::create([
                'idUser' => $request->idUser,
                'idPemesananTiket' => $request->idPemesananTiket,
                'metodePembayaran' => $request->metodePembayaran,
                'totalHarga' => $request->totalHarga,
            ]);

            // Optionally, you can associate the transaksi with pemesananTiket and user
            $pemesananTiket = PemesananTiket::find($request->idPemesananTiket);
            $user = User::find($request->idUser);

            // If you want to update the pemesananTiket's status or related information
            // For example, mark it as "paid" or "completed"
            // $pemesananTiket->status = 'paid';
            // $pemesananTiket->save();

            return response()->json([
                'status' => 'success',
                'message' => 'Transaction successfully created',
                'data' => $transaksi
            ], 200); // 201 Created
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'An error occurred while processing the transaction',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}

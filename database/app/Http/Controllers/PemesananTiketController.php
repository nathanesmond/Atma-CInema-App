<?php

namespace App\Http\Controllers;

use App\Models\PemesananTiket;
use Illuminate\Http\Request;
use Exception;

class PemesananTiketController extends Controller
{
    public function getAll($idJadwalTayang)
    {
        // Fetch reserved seats for the specific idJadwalTayang
        $allKursiDipesan = PemesananTiket::where('idJadwalTayang', $idJadwalTayang)
            ->pluck('kursiDipesan')
            ->flatten(); // Flattening in case kursiDipesan is an array

        return response()->json($allKursiDipesan);
    }


    public function store(Request $request)
    {
        $validated = $request->validate([
            'idJadwalTayang' => 'required|integer',
            'kursiDipesan' => 'required|array', // Ensure it's an array
        ]);

        // Fetch all existing booked seats for the same idJadwalTayang
        $existingSeats = PemesananTiket::where('idJadwalTayang', $validated['idJadwalTayang'])
            ->pluck('kursiDipesan')
            ->map(function ($item) {
                return json_decode($item, true); // Decode JSON string to array
            })
            ->flatten()
            ->toArray();

        // Check for seat conflicts
        $conflictingSeats = array_intersect($validated['kursiDipesan'], $existingSeats);

        if (!empty($conflictingSeats)) {
            return response()->json([
                'message' => 'Seats are taken',
                'conflictingSeats' => $conflictingSeats
            ], 401); // 400 Bad Request
        }

        // Encode kursiDipesan as a JSON string before saving
        $validated['kursiDipesan'] = json_encode($validated['kursiDipesan']);

        // Store the new transaction
        $transaksi = PemesananTiket::create($validated);

        try {
            return response()->json([
                'status' => true,
                'message' => 'Transaksi berhasil!',
                'data' => $transaksi
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Terjadi kesalahan saat menyimpan transaksi',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function deleteSeat($id)
    {
        $pemesananTiket = PemesananTiket::find($id);

        try {
            if (!$pemesananTiket) {
                return response()->json(['message' => 'Seat not found'], 404);
            } else {
                $pemesananTiket->delete();
            }

            return response()->json(['message' => 'Pemesanan Tiket removed successfully'], 200);
        } catch (Exception $e) {
            return response()->json(['error' => 'Failed to remove seats', 'message' => $e->getMessage()], 500);
        }
    }
}

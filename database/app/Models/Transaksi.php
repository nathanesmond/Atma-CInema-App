<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaksi extends Model
{
    use HasFactory;
    public $timestamps = false;

    protected $table = "transaksis";

    protected $primaryKey = "id";

    protected $fillable = [
        'idUser',
        'idPemesananTiket',
        'metodePembayaran',
        'totalHarga',
    ];

    public function users()
    {
        return $this->belongsTo(User::class, 'idUser', 'id');
    }

    public function pemesananTiket()
    {
        return $this->belongsTo(PemesananTiket::class, 'idPemesananTiket', 'id');
    }

    public function history()
    {
        return $this->hasOne(History::class, 'idTransaksi', 'id');
    }

}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class PemesananTiket extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $table = "pemesananTikets";

    protected $primaryKey = "id";

    protected $fillable = [
        'idJadwalTayang',
        'kursiDipesan',
    ];

    public function JadwalTayang(){
        return $this->belongsTo(JadwalTayang::class, 'idJadwalTayang', 'id');
    }
}

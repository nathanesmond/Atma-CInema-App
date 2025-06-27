<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('transaksis', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('idUser');
            $table->foreign('idUser')->references('id')->on('users')->onDelete('cascade');
            $table->unsignedBigInteger('idPemesananTiket');
            $table->foreign('idPemesananTiket')->references('id')->on('pemesananTikets')->onDelete('cascade');
            $table->string('metodePembayaran');
            $table->double('totalHarga');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transaksis');
    }
};

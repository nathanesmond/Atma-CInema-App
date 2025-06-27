<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('pemesananTikets', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('idJadwalTayang');
            $table->foreign('idJadwalTayang')->references('id')->on('jadwalTayangs')->onDelete('cascade');
            $table->longText('kursiDipesan');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pemesananTikets');
    }
};

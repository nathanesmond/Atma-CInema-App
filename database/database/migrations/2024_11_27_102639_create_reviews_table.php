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
        Schema::create('reviews', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('idFilm');
            $table->foreign('idFilm')->references('id')->on('films')->onDelete('cascade');
            $table->unsignedBigInteger('idHistory');
            $table->foreign('idHistory')->references('id')->on('histories')->onDelete('cascade');
            $table->string('review');
            $table->float('rating');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reviews');
    }
};

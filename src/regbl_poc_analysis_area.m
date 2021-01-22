%  regbl-poc-analysis
%
%      Nils Hamel - nils.hamel@alumni.epfl.ch
%      Huriel Reichel
%      Copyright (c) 2020-2021 Republic and Canton of Geneva
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.

    function regbl_poc_analysis_area( regbl_storage_path, regbl_metric_file, regbl_width, regbl_kernel_size )

        % import package %
        pkg load image;

        % create exportation directory %
        mkdir( [ regbl_storage_path '/regbl_analysis' ] );

        % create kernel %
        regbl_kernel = fspecial( 'gaussian', [ 1, 1 ] * regbl_kernel_size, regbl_kernel_size / 4 );

        % create areas representations %
        regbl_tarea = zeros( [ 1, 1 ] * ( regbl_width + regbl_kernel_size * 2 ) );
        regbl_farea = zeros( [ 1, 1 ] * ( regbl_width + regbl_kernel_size * 2 ) );

        % import metric egid %
        regbl_metric = dlmread( regbl_metric_file );

        % import listing %
        regbl_list = dlmread( [ regbl_storage_path '/regbl_list' ] );

        % parsing metric %
        for regbl_i = 1 : size( regbl_metric, 1 )

            % import deduction %
            regbl_deduce = dlmread( [ regbl_storage_path '/regbl_output/output_deduce/' num2str( regbl_metric(regbl_i) ) ] );

            % import reference %
            regbl_reference = dlmread( [ regbl_storage_path '/regbl_output/output_reference/' num2str( regbl_metric(regbl_i) ) ] );

            % import position %
            regbl_position = dlmread( [ regbl_storage_path '/regbl_output/output_position/' num2str( regbl_list(1,1) ) '/' num2str( regbl_metric(regbl_i) ) ] );

            % compute corner position %
            regbl_x = round( ( regbl_position(1,1) / regbl_list(1,6) ) * regbl_width ) + ( regbl_kernel_size / 2 );
            regbl_y = round( ( regbl_position(1,2) / regbl_list(1,7) ) * regbl_width ) + ( regbl_kernel_size / 2 );

            % compute ranges %
            regbl_u = [ regbl_x:regbl_x + regbl_kernel_size - 1 ];
            regbl_v = [ regbl_y:regbl_y + regbl_kernel_size - 1 ];

            % validation check %
            if ( regbl_reference <= regbl_deduce(1) ) && ( regbl_reference > regbl_deduce(2) )

                % update map %
                regbl_tarea( regbl_u, regbl_v ) = regbl_tarea( regbl_u, regbl_v ) + regbl_kernel;

            else

                % update map %
                regbl_farea( regbl_u, regbl_v ) = regbl_farea( regbl_u, regbl_v ) + regbl_kernel;

            end
            

        end

        % remove representation egdes %
        regbl_tarea = regbl_tarea( regbl_kernel_size : regbl_width + regbl_kernel_size - 1, regbl_kernel_size : regbl_width + regbl_kernel_size - 1 );
        regbl_farea = regbl_farea( regbl_kernel_size : regbl_width + regbl_kernel_size - 1, regbl_kernel_size : regbl_width + regbl_kernel_size - 1 );

        % normalize representation %
        regbl_tarea = uint8( ( regbl_tarea / max( regbl_tarea(:) ) ) * 255 );
        regbl_farea = uint8( ( regbl_farea / max( regbl_farea(:) ) ) * 255 );

        % create green representation %
        regbl_grep(:,:,1) = zeros( size( regbl_tarea ) );
        regbl_grep(:,:,2) = ones( size( regbl_tarea ) ) * 255;
        regbl_grep(:,:,3) = zeros( size( regbl_tarea ) );

        % export green representation %
        imwrite( uint8( regbl_grep ), [ regbl_storage_path '/regbl_analysis/analysis_area-valid-' regbl_poc_analysis_filename( regbl_metric_file ) '.tif' ], 'Alpha', flip( regbl_tarea', 1 ) );

        % create green representation %
        regbl_rrep(:,:,1) = ones( size( regbl_farea ) ) * 255;
        regbl_rrep(:,:,2) = zeros( size( regbl_farea ) );
        regbl_rrep(:,:,3) = zeros( size( regbl_farea ) );

        % export green representation %
        imwrite( uint8( regbl_rrep ), [ regbl_storage_path '/regbl_analysis/analysis_area-fail-' regbl_poc_analysis_filename( regbl_metric_file ) '.tif' ], 'Alpha', flip( regbl_farea', 1 ) );

    end


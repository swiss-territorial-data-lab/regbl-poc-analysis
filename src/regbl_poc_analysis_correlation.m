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

    function regbl_poc_analysis_correlation( regbl_corrfile_1, regbl_corrfile_2, regbl_xname, regbl_yname )

        % read correlation files %
        regbl_list_1 = dlmread( regbl_corrfile_1 );
        regbl_list_2 = dlmread( regbl_corrfile_2 );

        % indexation %
        regbl_index = 0;

        % allocate memory %
        regbl_corr = zeros( size( regbl_list_1, 1 ), 2 );

        % compose correlation array %
        for regbl_i = 1 : size( regbl_list_1, 1 )

            % detect corresponding egid %
            regbl_com = find( regbl_list_2(:,1) == regbl_list_1( regbl_i, 1 ) );

            % check consistency %
            if ( length( regbl_com ) == 1 )

                % update indexation %
                regbl_index = regbl_index + 1;

                % push correlation %
                regbl_corr( regbl_index, 1 ) = regbl_list_1( regbl_i, 2 );

                % push correlation %
                regbl_corr( regbl_index, 2 ) = regbl_list_2( regbl_com, 2 );

            end

        end

        % correct memory allocation %
        regbl_corr = regbl_corr( 1:regbl_index, : );

        % analsis bounding box %
        regbl_min = min( regbl_corr(:) );
        regbl_max = max( regbl_corr(:) );
        regbl_rng = regbl_max - regbl_min;

        % compute correlation factor %
        regbl_corval = corr( regbl_corr(:,1), regbl_corr(:,2) );

        % compute linear fitting %
        regbl_linear = polyfit( regbl_corr(:,1), regbl_corr(:,2), 1 );

        % compute linear plot %
        regbl_lplot = polyval( regbl_linear, [ regbl_min, regbl_max ] );

        % create figure %
        figure;
        hold on;
        box on;
        plot( regbl_corr(:,1), regbl_corr(:,2), 'ok', 'markerfacecolor', 'k', 'markersize', 3 );
        plot( regbl_corr(:,1), regbl_corr(:,2), 'xk', 'markerfacecolor', 'k', 'markersize', 6 );
        plot( [ regbl_min, regbl_max ], regbl_lplot, '-', 'color', [1 1 1] * 0.75 );
        axis( [ regbl_min, regbl_max, regbl_min, regbl_max ], 'equal' );
        text( regbl_min + regbl_rng * 0.1, regbl_max - regbl_rng * 0.1, num2str( regbl_corval, '%.2f' ), 'color', 'k', 'fontweight', 'bold' );
        xlabel( regbl_xname );
        ylabel( regbl_yname );

        % export figure %
        print( '-dpng', '-r150', 'output.png' );

    end

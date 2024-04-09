/**
 * @file main.cpp
 *
 * @license
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 *
 * Copyright (C) 2007-2011 Jos de Jong, http://www.speqmath.com
 *
 * @author 	Jos de Jong, <wjosdejong@gmail.com>
 * @date	2007, updated 2012-02-06
 */


// declarations
#include <cstdlib>
#include <cstdio>
#include <string>

#include "parser.h"


using namespace std;

int main(int argc, char *argv[])
{
    std::string expr;

    // create a parser object
    Parser prs;

    puts("Enter an expression an press Enter to calculate the result.");
    puts("Enter an empty expression to quit.");
    puts("");

    do
    {
        // request an expression
        printf("> ");
        expr.clear();
        for (;;)
        {
            char tmp[10];
            if (fgets(tmp, sizeof(tmp), stdin) == NULL )
                return EXIT_SUCCESS;
            // remove the trailing new line
            const size_t lg_tmp = strlen(tmp);
            if (lg_tmp > 0)
            {
                if (tmp[lg_tmp-1] == '\n')
                {
                    tmp[lg_tmp-1] = '\0';
                    expr += tmp;
                    break;
                }
                expr += tmp;
            }
        }

        if ( !expr.empty() )
        {
            try
            {
                // evaluate the expression
                char* result;
                result = prs.parse(expr.c_str());
                printf("\t%s\n", result);
            }
            catch (...)
            {
                printf("\tError: Unknown error occured in parser\n");
            }
        }
    } while ( !expr.empty() );

    return EXIT_SUCCESS;
}

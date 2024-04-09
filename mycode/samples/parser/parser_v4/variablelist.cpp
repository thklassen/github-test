/**
 * @file VariableList.cpp
 *
 * @brief The class VariableList can manages a list with variables.
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


#include "variablelist.h"

inline std::string toUpper(const char str[]);
/*
 * Returns true if the given name already exists in the variable list
 */
bool Variablelist::exist(const char* name)
{
    return var.find( toUpper( name ) ) != var.end() ;
}


/*
 * Add a name and value to the variable list
 */
bool Variablelist::add(const char* name, double value)
{
    var[ toUpper( name ) ] = value ;
    return true;
}

/*
 * Delete given variablename from the variable list
 */
bool Variablelist::del(const char* name)
{
    std::map<std::string,double>::const_iterator it = var.find( toUpper( name ) );
    if ( it != var.end() )
    {
        var.erase( it );
        return true;
    }
    return false;
}

/*
 * Get value of variable with given name
 */
bool Variablelist::get_value(const char* name,
                             double* value)
{
    const std::map<std::string,double>::const_iterator it = var.find( toUpper( name ) );
    if ( it != var.end() )
    {
        *value = it->second;
        return true;
    }
    return false;
}

bool Variablelist::set_value(const char* name, const double value)
{
    return add(name, value);
}

/*
 * str is copied to upper and made uppercase
 * upper is the returned string
 * str should be null-terminated
 */
void toupper(char upper[], const char str[])
{
    int i = -1;
    do
    {
        i++;
        upper[i] = std::toupper(str[i]);
    }
    while (str[i] != '\0');
}

std::string toUpper(const char str[])
{
    std::string upper;
    upper.reserve(NAME_LEN_MAX);
    int i = -1;
    do
    {
        i++;
        upper += std::toupper(str[i]);
    }
    while (str[i] != '\0');
    return upper;
}

#!/usr/bin/env python
# coding: utf-8

# In[1]:


import random

def calculate_average_performance(player_performance):
    return sum(player_performance.values()) / len(player_performance)

def select_best_team():
    man_city_performance = {
        'player1': 9.1,
        'player2': 8.8,
        'player3': 9.4,
    }

    inter_milan_performance = {
        'player1': 9.3,
        'player2': 9.0,
        'player3': 9.2,
    }

    # Calculating average performance ratings for each team
    man_city_avg_performance = calculate_average_performance(man_city_performance)
    inter_milan_avg_performance = calculate_average_performance(inter_milan_performance)

    # Considering team strategies and past records
    man_city_past_records = 0.8  # Winning percentage
    inter_milan_past_records = 0.7  # Winning percentage

    # Weighted scoring based on performance, strategies, and past records
    man_city_score = man_city_avg_performance + 0.2 * man_city_past_records
    inter_milan_score = inter_milan_avg_performance + 0.2 * inter_milan_past_records

    # Determine the best team
    if man_city_score > inter_milan_score:
        return 'Manchester City'
    elif inter_milan_score > man_city_score:
        return 'Inter Milan'
    else:
        # In case of a tie
        return random.choice(['Manchester City', 'Inter Milan'])

# best team
best_team = select_best_team()
print("The best team for the Champions League Final is:", best_team)


# In[ ]:





from django.contrib import admin

from .models import Experience


@admin.register(Experience)
class ExperienceAdmin(admin.ModelAdmin):
    list_display = ('title', 'category', 'tier', 'region', 'is_bookable', 'is_published')
    list_filter = ('category', 'tier', 'region', 'is_bookable', 'is_published')
    search_fields = ('title', 'description', 'address')
    prepopulated_fields = {'slug': ('title',)}

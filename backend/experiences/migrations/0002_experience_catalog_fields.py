from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ('experiences', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='experience',
            name='tier',
            field=models.CharField(
                choices=[
                    ('signature', 'Signature'),
                    ('featured', 'Featured'),
                    ('hidden_gem', 'Hidden Gem'),
                ],
                default='featured',
                max_length=20,
            ),
        ),
        migrations.AddField(
            model_name='experience',
            name='address',
            field=models.CharField(default='', max_length=255),
        ),
        migrations.AddField(
            model_name='experience',
            name='is_bookable',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='experience',
            name='booking_url',
            field=models.URLField(blank=True),
        ),
    ]
